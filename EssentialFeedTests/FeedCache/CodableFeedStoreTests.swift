//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 05/04/23.
//

import XCTest
@testable import EssentialFeed

class CodableFeedStore {
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}

final class CodableFeedStoreTests: XCTestCase {
    func test_retrieve_deliverEmptyOnEmptyCache() {
        let sut = CodableFeedStore()

        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableFeedStore()

        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same empty result, got \(firstResult) and \(secondResult) instead")
                }

                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1)
    }
}
