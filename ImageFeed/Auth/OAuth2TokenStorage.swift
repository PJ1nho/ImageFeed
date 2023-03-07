import UIKit

protocol OAuth2TokenStorageProtocol {
    var token: String { get }
}

class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private let userDefaults = UserDefaults.standard
    
    var token: String {
        get {
            return userDefaults.string(forKey: Keys.token.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    private enum Keys: String {
        case token
    }
}


