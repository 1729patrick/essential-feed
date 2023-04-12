//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import Foundation

protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>

    func load(completion: @escaping (Result) -> Void)
}
