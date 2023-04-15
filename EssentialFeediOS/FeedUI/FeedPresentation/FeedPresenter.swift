//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Patrick Battisti Forsthofer on 15/04/23.
//

import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
    private var feedLoader: FeedLoader
    var feedView: FeedView?
    var feedLoadingView: FeedLoadingView?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed () {
        feedLoadingView?.display(FeedLoadingViewModel(isLoading: true))

        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(FeedViewModel(feed: feed))
            }

            self?.feedLoadingView?.display(FeedLoadingViewModel(isLoading: false))
        }
    }
}
