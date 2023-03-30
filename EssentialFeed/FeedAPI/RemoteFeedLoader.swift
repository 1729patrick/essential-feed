//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient


    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { error, response in
            if let response = response {
               return completion(.invalidData)
            }

            return completion(.connectivity)
        }
    }
}
