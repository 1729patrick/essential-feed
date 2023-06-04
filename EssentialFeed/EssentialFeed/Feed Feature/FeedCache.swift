//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import Foundation

public protocol FeedCache {
	typealias Result = Swift.Result<Void, Error>
	
	func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
