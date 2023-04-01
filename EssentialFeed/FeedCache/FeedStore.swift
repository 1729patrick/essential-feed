//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 01/04/23.
//

import Foundation

protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}
