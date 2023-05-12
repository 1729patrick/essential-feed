//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

public struct FeedErrorViewModel {
	public let message: String?
	
	static var noError: FeedErrorViewModel {
		return FeedErrorViewModel(message: nil)
	}
	
	static func error(message: String) -> FeedErrorViewModel {
		return FeedErrorViewModel(message: message)
	}
}
