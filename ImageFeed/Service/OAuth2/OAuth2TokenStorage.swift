import Foundation
import SwiftKeychainWrapper

// MARK: - OAuth2 Token Storage

final class OAuth2TokenStorage {

    // MARK: - Public Properties

    static let shared = OAuth2TokenStorage()
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }

    // MARK: - Private Properties

    private let tokenKey = "token"

    // MARK: - Initializers

    private init() {}
}
