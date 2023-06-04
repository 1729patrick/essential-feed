//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import Foundation

public protocol FeedImageDataStore {
	func insert(_ data: Data, for url: URL) throws
	func retrieve(dataForURL url: URL) throws -> Data?
}
