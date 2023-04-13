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

    func test_load_doesNotDeleteCacheOnNonExpiredCache() {
        let currentDate = Date()
        let feed = uniqueImageFeed()
        let (store, sut) = makeSUT(currentDate: { currentDate })

        let nonExpiredTimestamp = currentDate.minusFeedCacheMaxAge().adding(seconds: 1)

        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_validateCache_deletesCacheOnExpirationCache() {
        let currentDate = Date()
        let feed = uniqueImageFeed()
        let (store, sut) = makeSUT(currentDate: { currentDate })

        let expirationCacheTimestamp = currentDate.minusFeedCacheMaxAge()

        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: expirationCacheTimestamp)

        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }

    func test_validateCache_deletesCacheOnExpiredCache() {
        let currentDate = Date()
        let feed = uniqueImageFeed()
        let (store, sut) = makeSUT(currentDate: { currentDate })

        let expiredTimestamp = currentDate.minusFeedCacheMaxAge().adding(seconds: -1)

        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)

        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }

    func test_validateCache_doesNotDeleteCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)

        sut?.validateCache()

        sut = nil
        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedMessages, [.retrieve])
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
