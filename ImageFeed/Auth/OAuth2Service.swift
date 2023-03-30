import UIKit

final class OAuth2Service {
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        if lastCode == code {
            completion(.failure(ImageFeedError.requestError))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
            print("Error: cannot create URL")
            completion(.failure(ImageFeedError.requestError))
            return
        }
        
        let requestData = OAuthRequestBody(
            clientId: "Uet2DAdZv_JdReZALmJ1SKCPwtO1L-IzEqvP4ZApnBs",
            clientSecret: "5saevBa1lP6LPQMCU4A0C7YEady-Pu04sYK1LkV6Ez0",
            redirectURI: "urn:ietf:wg:oauth:2.0:oob",
            code: code,
            grantType: "authorization_code")
        
        guard let jsonData = try? JSONEncoder().encode(requestData) else {
            print("Error: Trying to convert model to JSON data")
            completion(.failure(ImageFeedError.requestError))
            return
        }
        

        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
        

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthResponseBody, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                let token = data.accessToken
                completion(.success(token))
     
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                }
        

                self?.task = nil
                }
            }
            self.task = task
            task.resume()
        }
    }
