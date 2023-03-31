//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 31/03/23.
//

import XCTest
@testable import EssentialFeed

class URLSessionHttpClient {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://url.com.mt")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)

        let sut = URLSessionHttpClient(session: session)

        sut.get(from: url) { _ in }

        XCTAssertEqual(task.resumeCallCount, 1)
    }

    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://url.com.mt")!
        let error = NSError(domain: "any error", code: 1)

        let session = URLSessionSpy()
        session.stub(url: url, error: error)

        let sut = URLSessionHttpClient(session: session)

        let exp = expectation(description: "Wait for completion")

        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }


    // MARK: - Helpers
    private class URLSessionSpy: URLSession {
        private var stubs = [URL: Stub]()

        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Could't find stub for \(url)")
            }

            completionHandler(nil, nil, stub.error)
            return stub.task
        }

        func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
    }

    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() { }
    }

    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount: Int = .zero

        override func resume() {
            resumeCallCount += 1
        }
    }
}
