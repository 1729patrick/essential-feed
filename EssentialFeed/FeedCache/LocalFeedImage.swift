//
//  LocalFeedImage.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 02/04/23.
//

import Foundation

struct LocalFeedImage: Equatable, Codable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
