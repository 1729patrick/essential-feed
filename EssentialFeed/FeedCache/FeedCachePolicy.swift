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

    private static var maxCacheAgeInDays: Int { 7 }

    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }

        return date < maxCacheAge
    }
}
