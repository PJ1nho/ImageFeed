import Foundation

struct OAuthRequestBody: Codable {
    let clientId: String
    let clientSecret: String
    let redirectURI: String
    let code: String
    let grantType: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectURI = "redirect_uri"
        case code = "code"
        case grantType = "grant_type"
    }
}
