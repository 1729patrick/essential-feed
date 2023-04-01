//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Patrick Battisti Forsthofer on 01/04/23.
//

import Foundation

final class LocalFeedLoader {
    typealias SaveResult = Error?

    private let store: FeedStore
    private let currentDate: () -> Date

    init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }

            if let cachedDeletionError = error {
                completion(cachedDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }

    func cache(_ items: [FeedItem], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

private extension Array where Element == FeedItem {
    func toLocal() -> [LocalFeedItem] {
        map {
            LocalFeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.imageURL)
        }
    }
}
