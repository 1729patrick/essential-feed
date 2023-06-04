//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import Foundation

public protocol FeedImageDataCache {
	typealias Result = Swift.Result<Void, Error>
	
	func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
