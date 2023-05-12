//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import Foundation

public protocol FeedImageDataLoaderTask {
	func cancel()
}

public protocol FeedImageDataLoader {
	typealias Result = Swift.Result<Data, Error>
	
	func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
