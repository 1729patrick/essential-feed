//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//
public struct FeedImageViewModel<Image> {
	public let description: String?
	public let location: String?
	public let image: Image?
	public let isLoading: Bool
	public let shouldRetry: Bool
	
	public var hasLocation: Bool {
		return location != nil
	}
}
