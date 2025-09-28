import Foundation

// MARK: - Structures

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}

// MARK: - OAuth Service

final class OAuth2Service {
    
    // MARK: - Public Properties
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    
    private let dataStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private(set) var token: String? {
        get {
            return dataStorage.token
        }
        set {
            dataStorage.token = newValue
        }
    }

    // MARK: - Initializers
    
    private init() {}

    // MARK: - Public Methods
    
    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)

        if code == lastCode {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        task?.cancel()
        lastCode = code

        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Invalid request (failed to build URLRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = urlSession.objectTask(for: request) {
            [weak self ] (result: Result<OAuthTokenResponseBody, Error>) in
            
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                guard let self = self else { return }

                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.token = authToken
                    completion(.success(authToken))

                    self.task = nil
                    self.lastCode = nil

                case .failure(let error):
                    print("[fetchOAuthToken]: Request Error: \(error.localizedDescription)")
                    completion(.failure(error))

                    self.task = nil
                    self.lastCode = nil
                }
            }
        }
        self.task = task

        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard
            var urlComponents = URLComponents(
                string: "https://unsplash.com/oauth/token"
            )
        else {
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]

        guard let authTokenUrl = urlComponents.url else {
            return nil
        }

        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
}
