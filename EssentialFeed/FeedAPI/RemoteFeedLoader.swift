//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import Foundation


final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient


    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success(let data, let response):
                completion(FeedItemsMapper.map(data, response))
            case .failure(let error):
                completion(.failure(.connectivity))
            }
        }
    }
}
