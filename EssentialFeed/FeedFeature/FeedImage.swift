//
//  FeedImage.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import Foundation

struct FeedImage: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let url: URL
}
