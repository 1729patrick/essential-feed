//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import Foundation

final class FeedItemsMapper {
	private struct Root: Decodable {
		let items: [RemoteFeedItem]
	}
	
	static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
		guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
			throw RemoteFeedLoader.Error.invalidData
		}

		return root.items
	}
}
