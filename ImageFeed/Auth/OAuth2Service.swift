import UIKit

class OAuth2Service {
    func fetchAutoToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
            print("Error: cannot create URL")
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
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 299).contains(response.statusCode) else {
                print("Error: HTTP request failed")
                return
            }
            let responseToken = try? JSONDecoder().decode(OAuthResponseBody.self, from: data)
            guard let responseToken = responseToken else {
                return
            }
            let token = responseToken.accessToken
            completion(.success(token))
        }.resume()
    }
}
