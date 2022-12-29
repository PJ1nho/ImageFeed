//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 23.12.2022.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
}
