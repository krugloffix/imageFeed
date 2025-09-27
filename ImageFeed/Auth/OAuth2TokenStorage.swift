import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let storage = UserDefaults.standard
    private let tokenKey = "token"
    
    private init() {}
    
    var token: String? {
        get {
            storage.string(forKey: tokenKey)
        }
        set {
            storage.set(newValue, forKey: tokenKey)
        }
    }
    
    func clear() {
        storage.removeObject(forKey: tokenKey)
    }
}
