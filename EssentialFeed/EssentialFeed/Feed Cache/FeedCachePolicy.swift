//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//
import Foundation

final class FeedCachePolicy {
	private init() {}
	
	private static let calendar = Calendar(identifier: .gregorian)
	
	private static var maxCacheAgeInDays: Int {
		return 7
	}
	
	static func validate(_ timestamp: Date, against date: Date) -> Bool {
		guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
			return false
		}
		return date < maxCacheAge
	}
}
