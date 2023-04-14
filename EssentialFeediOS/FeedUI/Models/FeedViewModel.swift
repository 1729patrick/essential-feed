//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Patrick Battisti Forsthofer on 14/04/23.
//

import EssentialFeed

final public class FeedViewModel {
    typealias Observer<T> = (T) -> Void

    private var feedLoader: FeedLoader?
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed () {
        onLoadingStateChange?(true)

        feedLoader?.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }

            self?.onLoadingStateChange?(false)
        }
    }
}
