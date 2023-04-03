//
//  ValidateFeedCacheUseCacheTests.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 03/04/23.
//

import XCTest
@testable import EssentialFeed

final class ValidateFeedCacheUseCacheTests: XCTestCase {
    func test_init_doestNotMessageStoreUponCreation() {
        let (store, _) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_validateCache_deletesCacheOnRetrievalError() {
        let (store, sut) = makeSUT()

        sut.validateCache()
        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }

    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (store, sut) = makeSUT()

        sut.validateCache()
        store.completeRetrievalWithEmptyCache()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_doesNotDeleteCacheOnLessThanSevenDaysOldCache() {
        let currentDate = Date()
        let feed = uniqueFeedImage()
        let (store, sut) = makeSUT(currentDate: { currentDate })

        let lessThanSevenDaysOldTimestamp = currentDate.adding(days: -7).adding(seconds: 1)

        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimestamp)

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_validateCache_deletesCacheOnSevenDaysOldCache() {
        let currentDate = Date()
        let feed = uniqueFeedImage()
        let (store, sut) = makeSUT(currentDate: { currentDate })

        let sevenDaysOldTimestamp = currentDate.adding(days: -7)

        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimestamp)

        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }

    func test_validateCache_deletesCacheOnMoreThanSevenDaysOldCache() {
        let currentDate = Date()
        let feed = uniqueFeedImage()
        let (store, sut) = makeSUT(currentDate: { currentDate })

        let moreThanSevenDaysOldTimestamp = currentDate.adding(days: -7).adding(seconds: -1)

        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: moreThanSevenDaysOldTimestamp)

        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    // MARK: - Helpers

    func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (store: FeedStoreSpy, sut: LocalFeedLoader) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (store, sut)
    }
}
