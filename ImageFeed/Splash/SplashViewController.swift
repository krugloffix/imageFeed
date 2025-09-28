import UIKit

// MARK: - Identifiers

let showAuthenticationScreenSegueIdentifier =
    "showAuthenticationScreenSegueIdentifier"
let showMainScreenSegueIdentifier = "showMainScreenSegueIdentifier"

// MARK: - SplashViewController

final class SplashViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let logoHeight: CGFloat = 78
        static let logoWidth: CGFloat = 76
    }

    // MARK: - Private UI Properties

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Private Properties

    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if storage.token != nil {
            fetchProfile(token: storage.token ?? "")
        } else {
            performSegue(
                withIdentifier: showAuthenticationScreenSegueIdentifier,
                sender: nil
            )
        }
    }

    // MARK: - Private Methods

    private func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("Не удалось найти AuthViewController по идентификатору")
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            print("Invalid window configuration")
            return
        }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }

    private func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(imageView)
        imageView.image = UIImage(named: "splash_screen_icon")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(
                equalToConstant: Constants.logoWidth
            ),
            imageView.heightAnchor.constraint(
                equalToConstant: Constants.logoHeight
            ),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - Extensions

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)

        guard let token = storage.token else {
            return
        }

        fetchProfile(token: token)
    }

    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()

        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImage(
                    token: token,
                    username: profile.username
                ) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                print("Error fetching token: \(error)")
                break
            }
        }
    }
}
