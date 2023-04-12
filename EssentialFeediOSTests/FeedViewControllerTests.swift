//
//  EssentialFeediOSTests.swift
//  EssentialFeediOSTests
//
//  Created by Patrick Battisti Forsthofer on 12/04/23.
//


final class FeedViewController {
    init(loader: LoaderSpy)  {

    }
}

class LoaderSpy {
    private(set) var loadCallCount: Int = .zero
}


import XCTest
//@testable import EssentialFeediOS

final class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

}
