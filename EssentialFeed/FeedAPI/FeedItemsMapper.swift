//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 31/03/23.
//

import Foundation

final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [Item]

        var feedItems: [FeedItem] {
            items.map { $0.feedItem }
        }
    }

    struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL

        var feedItem: FeedItem {
            FeedItem(
                id: id,
                description: description,
                location: location,
                imageURL: image
            )
        }
    }

    private static let OK_200 = 200

    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }


        return .success(root.feedItems)
    }
}
