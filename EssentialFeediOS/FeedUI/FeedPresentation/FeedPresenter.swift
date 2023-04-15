//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Patrick Battisti Forsthofer on 15/04/23.
//

import EssentialFeed

protocol FeedLoadingView {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    private var feedLoader: FeedLoader
    var feedView: FeedView?
    var feedLoadingView: FeedLoadingView?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed () {
        feedLoadingView?.display(isLoading: true)

        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }

            self?.feedLoadingView?.display(isLoading: false)
        }
    }
}
