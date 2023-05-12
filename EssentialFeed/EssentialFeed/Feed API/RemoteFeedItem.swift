//
// Created by Patrick Battisti Forsthofer on 12/05/2023
// Copyright © 2023 Patrick Battisti Forsthofer. All rights reserved.
//
import Foundation

struct RemoteFeedItem: Decodable {
	let id: UUID
	let description: String?
	let location: String?
	let image: URL
}
