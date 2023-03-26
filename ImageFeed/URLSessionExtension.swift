//
//  URLSessionExtension.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 28.02.2023.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 299).contains(response.statusCode) else {
                print("Error: HTTP request failed")
                completion(.failure(ImageFeedError.requestError))
                return
            }
            
            let responseData = try? JSONDecoder().decode(T.self, from: data)
            guard let responseData = responseData else {
                completion(.failure(ImageFeedError.requestError))
                return
            }
            completion(.success(responseData))
        })
        return task
    }
}
