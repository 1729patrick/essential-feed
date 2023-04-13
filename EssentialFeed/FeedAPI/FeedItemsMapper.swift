//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 31/03/23.
//

import Foundation

final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedImage]
    }

    private static let OK_200 = 200

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedImage] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        

        return root.items
    }
}
