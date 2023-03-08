//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 08.03.2023.
//

import UIKit

final class ImagesListService {
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        
        guard let url = URL(string: "https://api.unsplash.com/photos") else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
    }
}
