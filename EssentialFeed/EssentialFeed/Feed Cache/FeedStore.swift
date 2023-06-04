//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
	func deleteCachedFeed() throws
	func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
	func retrieve() throws -> CachedFeed?
}
