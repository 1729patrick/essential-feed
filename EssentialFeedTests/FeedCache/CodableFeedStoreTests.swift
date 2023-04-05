//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 05/04/23.
//

import XCTest
@testable import EssentialFeed

class CodableFeedStore {
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date

        var localFeed: [LocalFeedImage] {
            feed.map { $0.local }
        }
    }

    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let imageURL: URL


        init(_ image: LocalFeedImage) {
            self.id = image.id
            self.description = image.description
            self.location = image.location
            self.imageURL = image.imageURL
        }

        var local: LocalFeedImage {
            LocalFeedImage(
                id: id,
                description: description,
                location: location,
                imageURL: imageURL
            )
        }
    }

    private let storeURL: URL

    init(storeURL: URL) {
        self.storeURL = storeURL
    }

    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }

        do {
            let decoder = JSONDecoder()
            let cache = try decoder.decode(Cache.self, from: data)
            completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
        } catch {
            completion(.failure(error))
        }
    }

    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        do {
            let encoder = JSONEncoder()

            let cache = Cache(
                feed: feed.map(CodableFeedImage.init),
                timestamp: timestamp
            )

            let encoded = try encoder.encode(cache)

            try encoded.write(to: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func deleteCachedFeed(completion: @escaping FeedStore.DeletionCompletion) {
        completion(nil)
    }
}

final class CodableFeedStoreTests: XCTestCase {
    override func setUp() {
        super.setUp()
        deleteStoreArtifacts()
    }

    override func tearDown() {
        super.tearDown()
        deleteStoreArtifacts()
    }

    func test_retrieve_deliverEmptyOnEmptyCache() {
        let sut = makeSUT(storeURL: storeURL())

        expect(sut, toRetrieve: .empty)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT(storeURL: storeURL())
        expect(sut, toRetrieveTwice: .empty)
    }

    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT(storeURL: storeURL())

        let feed = uniqueImageFeed().local
        let timestamp = Date()

        insert((feed, timestamp), to: sut)

        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT(storeURL: storeURL())

        let feed = uniqueImageFeed().local
        let timestamp = Date()

        insert((feed, timestamp), to: sut)

        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))
    }

    func test_retrieve_deliversFailureOnRetrievalError() {
        let sut = makeSUT(storeURL: storeURL())

        try! "invalid data".write(to: storeURL(), atomically: false, encoding: .utf8)

        expect(sut, toRetrieve: .failure(anyNSError()))
    }

    func test_retrieve_hasNoSideEffectsOnFailure() {
        let sut = makeSUT(storeURL: storeURL())

        try! "invalid data".write(to: storeURL(), atomically: false, encoding: .utf8)

        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    

    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT(storeURL: storeURL())

        let firstInsertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache successfully")

        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()

        let latestInsertionError = insert((latestFeed, latestTimestamp), to: sut)
        XCTAssertNil(latestInsertionError, "Expected to override cache successfully")

        expect(sut, toRetrieve: .found(feed: latestFeed, timestamp: latestTimestamp))
    }

    func test_insertion_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)

        let feed = uniqueImageFeed().local
        let timestamp = Date()

        let insertionError = insert((feed, timestamp), to: sut)

        XCTAssertNotNil(insertionError, "Expected cache insertions fails with an error")
    }

    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT(storeURL: storeURL())
        let exp = expectation(description: "Wait for cache deletion")

        sut.deleteCachedFeed { deletionError in
            XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        expect(sut, toRetrieve: .empty)
    }

    // MARK: - Helpers

    private func makeSUT(storeURL: URL, file: StaticString = #filePath, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func storeURL() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }

    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: storeURL())
    }

    @discardableResult private func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: CodableFeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")

        var insertionError: Error?
        sut.insert (cache.feed, timestamp: cache.timestamp) { receivedError in
            insertionError = receivedError
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
        return insertionError
    }

    private func expect(_ sut: CodableFeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult)
        expect(sut, toRetrieve: expectedResult)
    }

    private func expect(_ sut: CodableFeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break

            case let (.found(expected), .found(retrieved)):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)

            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
}
