//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import XCTest
@testable import EssentialFeed

final class EssentialFeedTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertNil(client.requestedURL)
    }

    func test_init_requestsDataFromURL() {
        let url = URL(string: "https://some-url.com.mt")!

        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURL, url)
    }

    // MARK: - Helpers
    // SUT = system under test
    private func makeSUT(url: URL = URL(string: "https://some-url.com.mt")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()

        let sut = RemoteFeedLoader(url: url, client: client)

        return (sut: sut, client: client)
    }

    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?

       func get(from url: URL) {
            self.requestedURL = url
        }
    }
}
