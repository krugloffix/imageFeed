import Foundation

// MARK: - Structures

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

// MARK: - Profile Service

final class ProfileService {
    // MARK: - Public Properies
    static let shared = ProfileService()

    // MARK: - Private Properties

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?

    // MARK: - Public Methods

    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        task?.cancel()

        guard let request = makeProfileRequest(token: token)
        else {
            let error = URLError(.badURL)
            print("Failed to create request: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        let task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let result):
                let profile = Profile(
                    username: result.username,
                    name: "\(result.firstName) \(result.lastName ?? "")"
                        .trimmingCharacters(in: .whitespaces),
                    loginName: "@\(result.username)",
                    bio: result.bio
                )
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("Failed to fetch profile: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }

    // MARK: - Private Methods

    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let baseURL = Constants.defaultBaseURL else { return nil }
        let url = baseURL.appendingPathComponent("me")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
