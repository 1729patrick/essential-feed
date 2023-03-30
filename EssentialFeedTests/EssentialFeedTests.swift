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

        XCTAssert(client.requestedURLs.isEmpty)
    }

    func test_init_requestsDataFromURL() {
        let url = URL(string: "https://some-url.com.mt")!

        let (sut, client) = makeSUT(url: url)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "", code: 0)

        var capturedError: RemoteFeedLoader.Error?

        sut.load { error in capturedError = error }

        XCTAssertEqual(capturedError, .connectivity)
    }

    // MARK: - Helpers
    // SUT = system under test
    private func makeSUT(url: URL = URL(string: "https://some-url.com.mt")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()

        let sut = RemoteFeedLoader(url: url, client: client)

        return (sut: sut, client: client)
    }

    class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: Error?

        func get(from url: URL, completion: @escaping (Error) -> Void = { _ in }) {
           if let error = error {
               completion(error)
           }

           requestedURLs.append(url)
        }
    }
}
