//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import Foundation

public final class FeedImageDataMapper {
	public enum Error: Swift.Error {
		case invalidData
	}
	
	public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
		guard response.isOK, !data.isEmpty else {
			throw Error.invalidData
		}
		
		return data
	}
}
