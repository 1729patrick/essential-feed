//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    let url: URL
    let client: HTTPClient

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

final class EssentialFeedTests: XCTestCase {
    func testDoesNotRequestDataFromURL() {
        let (_, client) = makeSUT(url: url)

        XCTAssertNil(client.requestedURL)
    }

    func testRequestDataFromURL() {
        let url = URL(string: "https://some-url.com.mt")!

        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURL, url)
    }

    // MARK: - Helpers
    // SUT = system under test
    private func makeSUT(url: URL) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
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
