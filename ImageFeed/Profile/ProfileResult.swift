//
//  ProfileRequestBody.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 15.02.2023.
//

import UIKit

struct ProfileResult: Decodable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

