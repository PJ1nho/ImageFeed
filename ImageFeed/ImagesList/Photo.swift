//
//  Photo.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 08.03.2023.
//

import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
