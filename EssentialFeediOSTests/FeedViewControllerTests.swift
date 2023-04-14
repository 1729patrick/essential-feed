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
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
}
