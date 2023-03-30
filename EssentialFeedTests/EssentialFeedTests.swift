//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 30/03/23.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://some-url.com.mt")!
    }

    let url: URL
    let client: HTTPClient

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}

class HTTPClient {
    static let shared = HTTPClient()

    var requestedURL: URL?

    private init() { }
}


final class EssentialFeedTests: XCTestCase {

    func testDoesNotRequestDataFromURL() {
        let client = HTTPClient.shared

        XCTAssertNil(client.requestedURL)
    }

    func testRequestDataFromURL() {
        let url = URL(string: "https://some-url.com.mt")!

        let client = HTTPClient.shared

        let sut = RemoteFeedLoader(url: url, client: client) //system under test

        sut.load()

        XCTAssertEqual(client.requestedURL, url)

    }
}
