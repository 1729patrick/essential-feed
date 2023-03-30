//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import Foundation

struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}

extension FeedItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        case imageURL = "image"
    }
}
