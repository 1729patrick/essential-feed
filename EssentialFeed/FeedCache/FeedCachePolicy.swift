//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 03/04/23.
//

import Foundation

struct FeedCachePolicy {
    private init() {}

    static let calendar = Calendar(identifier: .gregorian)

    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        let maxCacheAgeInDays = 7

        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }

        return date < maxCacheAge
    }
}
