//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//

public struct FeedImageViewModel {
	public let description: String?
	public let location: String?
	
	public var hasLocation: Bool {
		return location != nil
	}
}
