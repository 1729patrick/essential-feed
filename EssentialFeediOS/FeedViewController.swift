//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Patrick Battisti Forsthofer on 14/04/23.
//

import SwiftUI
import EssentialFeed

final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?

    convenience init(loader: FeedLoader)  {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)

        load()
    }

    @objc func load() {
        refreshControl?.beginRefreshing()

        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}
