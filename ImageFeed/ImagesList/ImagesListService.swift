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
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let token = OAuth2TokenStorage().token
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = nextPage
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)&client_id=\(AccessKey)") else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .failure(let error):
                print ("fail")
            case .success(let data):
                print ("success")
                let photos = data.map {return Photo(id: $0.id, size: .init(width: $0.width, height: $0.height), createdAt: DateFormatterService.shared.responseDateFormatter.date(from: $0.createdAt), welcomeDescription: $0.description, thumbImageURL: $0.urls.thumb, largeImageURL: $0.urls.full, isLiked: $0.likedByUser) }
                
                DispatchQueue.main.async {
                    self?.photos.append(contentsOf: photos)
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["photos": self?.photos])
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like?client_id=\(AccessKey)") else {
            print("Error: cannot create URL")
            completion(.failure(ImageFeedError.requestError))
            return
        }
        var request = URLRequest(url: url)
        
        if let photoIndex = photos.firstIndex { $0.id == photoId } {
            photos[photoIndex].isLiked = isLike
        }
        
        
        if isLike == true {
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    completion(.failure(NSError(domain: "Failure HTTP code", code: 0)))
                    return
                }
                if let data = data {
                    print("Response: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.success(true))
                }
            }.resume()
        } else {
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    completion(.failure(NSError(domain: "Failure HTTP code", code: 0)))
                    return
                }
                if let data = data {
                    print("Response: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.success(false))
                }
            }.resume()
        }
    }
}
