//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 03/04/23.
//

import Foundation
@testable import EssentialFeed

func uniqueImage() -> FeedImage {
    FeedImage(
        id: UUID(),
        description: "any description",
        location: "any location",
        url: URL(string: "https://www.image.com.mt")!
    )
}

func uniqueFeedImage() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map {
        LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.url)
    }

    return (models, local)
}

extension Date {
    private var feedCacheMaxAgeInDays: Int { 7 }

    func minusFeedCacheMaxAge() -> Date {
        adding(days: -feedCacheMaxAgeInDays)
    }
}

extension Date {
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }

    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
