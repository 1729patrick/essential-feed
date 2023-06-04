//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

import Foundation

public enum ImageCommentsEndpoint {
	case get(UUID)
	
	public func url(baseURL: URL) -> URL {
		switch self {
		case let .get(id):
			return baseURL.appendingPathComponent("/v1/image/\(id)/comments")
		}
	}
}
