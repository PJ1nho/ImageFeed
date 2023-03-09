//
//  UserResult.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 25.02.2023.
//

import UIKit

struct UserResult: Codable {
    let small: String
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
        
        enum URLCodingKeys: String, CodingKey {
            case small = "small"
        }
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let urlContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.URLCodingKeys.self, forKey: .profileImage)
        small = try urlContainer.decode(String.self, forKey: .small)
    }
    
    func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: CodingKeys.self)
        var metadataContainer = rootContainer.nestedContainer(keyedBy: CodingKeys.URLCodingKeys.self, forKey: .profileImage)
        try metadataContainer.encode(small, forKey: .small)
    }
}
