//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 02/04/23.
//

import XCTest
@testable import EssentialFeed

final class LoadFeedFromCacheUseCaseTests: XCTestCase {
    func test_init_doestNotMessageStoreUponCreation() {
        let (store, _) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_load_requestsCacheRetrieval() {
        let (store, sut) = makeSUT()
        let retrievalError = anyNSError()

        let exp = expectation(description: "Wait for load completion")

        var receivedErrors = [NSError?]()
        sut.load { result in
            switch result {
            case .failure(let error):
                receivedErrors.append(error as NSError)
            default:
                XCTFail("Expected failure, got \(result) instead")
            }

            exp.fulfill()
        }

        store.completeRetrieval(with: retrievalError)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(receivedErrors, [retrievalError])
    }

    func test_load_failsOnRetrievalError() {
        let (store, sut) = makeSUT()

        sut.load { _ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_deliversNoImagesOnEmptyCache() {
        let (store, sut) = makeSUT()

        let exp = expectation(description: "Wait for load completion")

        var receivedImages = [FeedImage]()
        sut.load { result in
            switch result {
            case .success(let images):
                receivedImages.append(contentsOf: images)
            default:
                XCTFail("Expected success, got \(result) instead")
            }

            exp.fulfill()
        }

        store.completeRetrievalSuccessfully()

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(receivedImages, [])
    }


    // MARK: - Helpers

    func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (store: FeedStoreSpy, sut: LocalFeedLoader) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (store, sut)
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
