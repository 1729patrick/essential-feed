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

    typealias Result = LoadFeedResult<Error>

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load(completion: @escaping (LoadFeedResult<Error>) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case .success(let data, let response):
                completion(FeedItemsMapper.map(data, response))
            case .failure(let error):
                completion(.failure(Error.connectivity))
            }
        }
    }
}
