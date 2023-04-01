//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 01/04/23.
//

import XCTest
@testable import EssentialFeed

final class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doestNotMessageStoreUponCreation() {
        let (store, _) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_save_requestsCacheDeletion() {
        let (store, sut) = makeSUT()

        sut.save(uniqueFeedImage().models) { _ in }

        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }

    func test_save_doestNotRequestCacheInsertionOnDeletionError() {
        let (store, sut) = makeSUT()

        let deletionError = anyNSError()

        sut.save(uniqueFeedImage().models) { _ in }
        store.completeDeletion(with: deletionError)

        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }

    func test_save_requestsCacheInsertionWithTimestampOnCacheDeletion() {
        let timestamp = Date()

        let (store, sut) = makeSUT(currentDate: { timestamp })
        let feed = uniqueFeedImage()

        sut.save(feed.models) { _ in }
        store.completeDeletionSuccessfully()

        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed, .insert(feed.local, timestamp)])
    }

    func test_save_failsOnDeletionError() {
        let (store, sut) = makeSUT()
        let deletionError = anyNSError()

        expect(sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }

    func test_save_failsOnInsertionError() {
        let (store, sut) = makeSUT()
        let insertionError = anyNSError()

        expect(sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }

    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (store, sut) = makeSUT()

        expect(sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }

    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalFeedLoader.SaveResult]()
        sut?.save(uniqueFeedImage().models) { receivedResults.append($0) }

        sut = nil

        store.completeDeletion(with: anyNSError())

        XCTAssertTrue(receivedResults.isEmpty)
    }

    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalFeedLoader.SaveResult]()
        sut?.save(uniqueFeedImage().models) { receivedResults.append($0) }

        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())


        XCTAssertTrue(receivedResults.isEmpty)
    }

    // MARK: - Helpers
    func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (store: FeedStoreSpy, sut: LocalFeedLoader) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (store, sut)
    }

    private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")

        var receivedError: Error?
        sut.save(uniqueFeedImage().models) { error in
            receivedError = error
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }

    func uniqueImage() -> FeedImage {
        FeedImage(
            id: UUID(),
            description: "any description",
            location: "any location",
            url: URL(string: "https://www.image.com.mt")!
        )
    }

    func uniqueFeedImage() -> (models: [FeedImage], local: [LocalFeedItem]) {
        let models = [uniqueImage(), uniqueImage()]
        let local = models.map {
            LocalFeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.url)
        }

        return (models, local)
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

    class FeedStoreSpy: FeedStore  {
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()

        enum ReceivedMessages: Equatable {
            case deleteCachedFeed
            case insert([LocalFeedItem], Date)
        }

        private(set) var receivedMessages = [ReceivedMessages]()

        func deleteCachedFeed(completion: @escaping DeletionCompletion) {
            deletionCompletions.append(completion)
            receivedMessages.append(.deleteCachedFeed)
        }

        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](error)
        }

        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }

        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](error)
        }

        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }

        func insert(_ feed: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
            receivedMessages.append(.insert(feed, timestamp))
        }
    }
}
