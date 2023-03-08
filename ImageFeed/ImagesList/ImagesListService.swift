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
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)") else {
            print("Error: cannot create URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        var task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .failure(let error):
                print ("fail")
            case .success(let data):
                print ("success")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let photos = data.map {return Photo(id: $0.id, size: .init(width: $0.width, height: $0.height), createdAt: dateFormatter.date(from: $0.createdAt), welcomeDescription: $0.description, thumbImageURL: $0.urls.thumb, largeImageURL: $0.urls.full, isLiked: $0.likedByUser) }
                DispatchQueue.main.async {
                    self?.photos.append(contentsOf: photos)
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.DidChangeNotification,
                            object: self,
                            userInfo: ["photos": self?.photos])
                }
            }
        }
        self.task = task
        task.resume()
    }
}
