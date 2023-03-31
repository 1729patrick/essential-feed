//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import Foundation

enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

extension LoadFeedResult: Equatable where Error: Equatable { }

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult<Swift.Error>) -> Void)
}
