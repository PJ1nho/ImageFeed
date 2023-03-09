import UIKit
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String { get }
}

class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private let keyChain = KeychainWrapper.standard
    
    var token: String {
        get {
            return keyChain.string(forKey: Keys.token.rawValue) ?? ""
        }
        set {
            keyChain.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    private enum Keys: String {
        case token
    }
}


