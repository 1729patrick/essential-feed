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
        HTTPClient.shared.get(from: URL(string: "https://some-url.com.mt")!)
    }

    let url: URL
    let client: HTTPClient

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}

class HTTPClient {
    static var shared = HTTPClient()


    func get(from url: URL) { }
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

   override func get(from url: URL) {
        self.requestedURL = url
    }
}


final class EssentialFeedTests: XCTestCase {

    func testDoesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client

        XCTAssertNil(client.requestedURL)
    }

    func testRequestDataFromURL() {
        let url = URL(string: "https://some-url.com.mt")!

        let client = HTTPClientSpy()
        HTTPClient.shared = client

        let sut = RemoteFeedLoader(url: url, client: client) //system under test

        sut.load()

        XCTAssertEqual(client.requestedURL, url)

    }
}
