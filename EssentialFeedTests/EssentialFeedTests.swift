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

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

   func get(from url: URL) {
        self.requestedURL = url
    }
}


final class EssentialFeedTests: XCTestCase {
    func testDoesNotRequestDataFromURL() {
        let client = HTTPClientSpy()

        XCTAssertNil(client.requestedURL)
    }

    func testRequestDataFromURL() {
        let url = URL(string: "https://some-url.com.mt")!

        let client = HTTPClientSpy()

        let sut = RemoteFeedLoader(url: url, client: client) //system under test

        sut.load()

        XCTAssertEqual(client.requestedURL, url)

    }
}
