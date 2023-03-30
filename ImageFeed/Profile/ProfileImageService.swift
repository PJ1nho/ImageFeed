//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 25.02.2023.
//

import UIKit

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    private let token = OAuth2TokenStorage().token
    
    var task: URLSessionTask?
    var lastUsername: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        if lastUsername == username  {
            completion(.failure(ImageFeedError.requestError))
            return
        }
        task?.cancel()
        lastUsername = username
        
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("Error: cannot create URL")
            completion(.failure(ImageFeedError.requestError))
            return
        }
        

        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
        

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                self?.avatarURL = data.small
                completion(.success(data.small))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": data.small])
                

                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                }
                

                self?.task = nil
                self?.lastUsername = nil
            }
        }
        self.task = task
        task.resume()
    }
}
