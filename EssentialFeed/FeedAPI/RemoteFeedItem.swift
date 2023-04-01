//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 02/04/23.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
