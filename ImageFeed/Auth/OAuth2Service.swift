import Foundation

struct OAuthTokenResponseBody: Decodable {
    let access_token: String
    let token_type: String
    let scope: String
    let created_at: Int
}

final class OAuth2Service {
    static let shared = OAuth2Service()

    private init() {}

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

    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            print("Invalid request (failed to build URLRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = URLSession.shared.data(for: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(
                        OAuthTokenResponseBody.self,
                        from: data
                    )
                    print("Successfully decoded token response")
                    completion(.success(response.access_token))
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response body:\n\(jsonString)")
                    }
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                switch error {
                case NetworkError.httpStatusCode(let code):
                    print("Unsplash returned HTTP status code: \(code)")
                case NetworkError.urlRequestError(let underlying):
                    print(
                        "URLRequest error: \(underlying.localizedDescription)"
                    )
                case NetworkError.urlSessionError:
                    print("URLSession error (no data and no error returned)")
                default:
                    print("Unexpected error: \(error.localizedDescription)")
                }
                completion(.failure(error))
            }

        }

        task.resume()
    }
}
