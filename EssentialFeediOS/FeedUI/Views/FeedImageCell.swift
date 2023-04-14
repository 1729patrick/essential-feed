//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Patrick Battisti Forsthofer on 14/04/23.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    public let locationContainer = UIView()
    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let feedImageContainer = UIView()
    public let feedImageView = UIImageView()

    var onRetry: (() -> Void)?

    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()


    @objc private func retryButtonTapped() {
        onRetry?()
    }
}
