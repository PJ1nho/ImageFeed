import UIKit

let AccessKey = "Uet2DAdZv_JdReZALmJ1SKCPwtO1L-IzEqvP4ZApnBs"
let SecretKey = "5saevBa1lP6LPQMCU4A0C7YEady-Pu04sYK1LkV6Ez0"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!

let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: AccessKey,
                                     secretKey: SecretKey,
                                     redirectURI: RedirectURI,
                                     accessScope: AccessScope,
                                     authURLString: UnsplashAuthorizeURLString,
                                     defaultBaseURL: DefaultBaseURL)
        }
}
