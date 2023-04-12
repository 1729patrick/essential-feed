//
//  EssentialFeediOSTests.swift
//  EssentialFeediOSTests
//
//  Created by Patrick Battisti Forsthofer on 12/04/23.
//

import XCTest
import UIKit
//@testable import EssentialFeediOS


final class FeedViewController: UIViewController {
    private var loader: LoaderSpy?

    convenience init(loader: LoaderSpy)  {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loader?.load()
    }
}

class LoaderSpy {
    private(set) var loadCallCount: Int = .zero

    func load() {
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
