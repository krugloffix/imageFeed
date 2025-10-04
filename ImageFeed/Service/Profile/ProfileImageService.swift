import Foundation

// MARK: - Structures

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct UserResult: Codable {
    let profileImage: ProfileImage
}

// MARK: - Profile Image Service

final class ProfileImageService {

    // MARK: - Public Properties

    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(
        rawValue: "ProfileImageProviderDidChange"
    )

    // MARK: - Private Properties

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?

    // MARK: - Public Methods
    func fetchProfileImage(
        username: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        task?.cancel()

        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "ProfileImageService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authorization token missing"])))
            return
        }
        
        guard
            let request = makeProfileImageRequest(
                token: token,
                username: username
            )
        else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let result):
                guard let self else { return }

                let profileImageUrl = result.profileImage.small
                self.avatarURL = profileImageUrl
                completion(.success(profileImageUrl))
                                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageUrl]
                )
            case .failure(let error):
                print("Failed to fetch profile image: \(error)")
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }

    // MARK: - Private Methods

    private func makeProfileImageRequest(token: String, username: String)
        -> URLRequest?
    {
        guard let baseURL = Constants.defaultBaseURL else { return nil }
        let url = baseURL.appendingPathComponent(
            "users/\(username)/"
        )

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return request
    }
}
