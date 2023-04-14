//
//  EssentialFeediOSTests.swift
//  EssentialFeediOSTests
//
//  Created by Patrick Battisti Forsthofer on 12/04/23.
//

import XCTest
import UIKit
@testable import EssentialFeed


final class FeedViewController: UIViewController {
    private var loader: FeedLoader?

    convenience init(loader: FeedLoader)  {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loader?.load { _ in }
    }
}

class LoaderSpy: FeedLoader {
    private(set) var loadCallCount: Int = .zero

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        loadCallCount += 1
    }
}

final class FeedViewControllerTests: XCTestCase {
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }

}
