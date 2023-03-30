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

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        let clientError = NSError(domain: "", code: 0)

        expect(sut, error: .connectivity) {
            client.complete(with: clientError)
        }
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, statusCode in
            expect(sut, error: .invalidData) {
                client.complete(withStatusCode: statusCode, at: index)
            }
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, error: .invalidData) {
            let invalidJSON = Data("invalid.json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {

    }

    // MARK: - Helpers
    // SUT = system under test
    private func makeSUT(url: URL = URL(string: "https://some-url.com.mt")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()

        let sut = RemoteFeedLoader(url: url, client: client)

        return (sut, client)
    }

    private func expect(_ sut: RemoteFeedLoader, error: RemoteFeedLoader.Error, when action: @escaping () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()

        sut.load { capturedResults.append($0) }

        action()

        XCTAssertEqual(capturedResults, [.failure(error)], file: file, line: line)
    }

    class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

        var requestedURLs: [URL] {
            messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void = { _ in }) {
            messages.append((url, completion))
        }

        func complete(with error: Error, at index: Int = .zero) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode statusCode: Int, data: Data = Data(), at index: Int = .zero) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!

            messages[index].completion(.success(data, response))
        }
    }
}
