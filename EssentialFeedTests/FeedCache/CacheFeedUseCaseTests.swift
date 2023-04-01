//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 01/04/23.
//

import XCTest


class LocalFeedLoader {
    init(store: FeedStore) {

    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

final class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doestNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)

        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }

}
