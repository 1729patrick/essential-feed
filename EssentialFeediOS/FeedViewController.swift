//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Patrick Battisti Forsthofer on 14/04/23.
//

import SwiftUI
import EssentialFeed

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) -> FeedImageDataLoaderTask
}


final class FeedViewController: UITableViewController {
    private var feedLoader: FeedLoader?
    private var tableModel = [FeedImage]()
    private var imageLoader: FeedImageDataLoader?
    private var tasks = [IndexPath: FeedImageDataLoaderTask]()

    convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader)  {
        self.init()
        self.feedLoader = feedLoader

        self.imageLoader = imageLoader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)

        load()
    }

    @objc private func load() {
        refreshControl?.beginRefreshing()

        feedLoader?.load { [weak self] result in
            if let feed = try? result.get() {
                self?.tableModel = feed
                self?.tableView.reloadData()
            }

            self?.refreshControl?.endRefreshing()
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()

        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description

        tasks[indexPath] = imageLoader?.loadImageData(from: cellModel.url)

        return cell
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
}