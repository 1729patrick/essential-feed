//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import Foundation

enum LoadFeedResult {
    case success(FeedItem)
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
