//
//  SharedTestsHelpers.swift
//  EssentialFeedTests
//
//  Created by Patrick Battisti Forsthofer on 03/04/23.
//

import Foundation

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyHTTPURLResponse() -> HTTPURLResponse {
    return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
}

func nonHTTPURLResponse() -> URLResponse {
    return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}

func anyURL() -> URL {
    URL(string: "https://url.com.mt")!
}
