//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Patrick Battisti Forsthofer on 14/04/23.
//

import SwiftUI
import EssentialFeed

final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var refreshController: FeedRefreshViewController?
    private var tableModel = [FeedImage]() {
        didSet { tableView.reloadData() }
    }
    private var imageLoader: FeedImageDataLoader?

    private var cellControllers = [IndexPath: FeedImageCellController]()

    convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader)  {
        self.init()

        self.refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        self.imageLoader = imageLoader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = refreshController?.view
        refreshController?.onRefresh = { [weak self] feed in
            self?.tableModel = feed
        }

        tableView.prefetchDataSource = self
        refreshController?.refresh()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view()
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(removeCellController)
    }

    private func removeCellController(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }

    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        let cellModel = tableModel[indexPath.row]
        let cellController = FeedImageCellController(model: cellModel, imageLoader: imageLoader!)

        cellControllers[indexPath] = cellController

        return cellController
    }
}
