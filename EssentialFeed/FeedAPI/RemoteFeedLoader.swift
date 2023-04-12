//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import Foundation


final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient


    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    typealias Result = FeedLoader.Result

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case .success(let data, let response):
                completion(RemoteFeedLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

extension Array where Element == RemoteFeedImage {
    func toModels() -> [FeedImage] {
        map {
            FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
        }
    }
}


