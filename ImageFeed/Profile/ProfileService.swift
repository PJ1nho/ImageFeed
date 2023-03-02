//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 15.02.2023.
//

import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        if lastToken == token  { return }
        task?.cancel()
        lastToken = token
        
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            print("Error: cannot create URL")
            return
        }
        
        UIBlockingProgressHUD.show()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                let profileResults = ProfileResult(
                    username: data.username,
                    firstName: data.firstName,
                    lastName: data.lastName,
                    bio: data.bio)
                
                let name = profileResults.firstName + " " + profileResults.lastName
                let loginName = "@" + profileResults.username
                let bio = profileResults.bio ?? ""
                
                let profile = Profile(
                    name: name,
                    loginName: loginName,
                    bio: bio)
                
                self?.profile = profile
                
                UIBlockingProgressHUD.dismiss()
                
                self?.task = nil
                self?.lastToken = nil
                completion(.success(profile))
            }
        }
        self.task = task
        task.resume()
    }
}
