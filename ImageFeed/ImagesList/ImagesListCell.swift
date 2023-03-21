//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 23.12.2022.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction func likeButtonClicked() {
        delegate?.imagesListCellDidTapLike(self)
    }
    
    static let reuseIdentifier = "ImagesListCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            likeButton.imageView?.image = UIImage(named: "likeActive")
        } else {
            likeButton.imageView?.image = UIImage(named: "likeInactive")
        }
    }
}

