//
//  RemoteFeedImage.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 02/04/23.
//

import Foundation

struct RemoteFeedImage: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let url: URL
}
