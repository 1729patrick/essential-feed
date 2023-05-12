//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//
import Foundation

public protocol FeedImageDataStore {
	typealias RetrievalResult = Swift.Result<Data?, Error>
	typealias InsertionResult = Swift.Result<Void, Error>

	func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
	func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}
