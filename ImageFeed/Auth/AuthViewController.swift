import ProgressHUD
import UIKit

// MARK: - Protocols

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

// MARK: Auth View Controller

final class AuthViewController: UIViewController {

    // MARK: - Private Properties

    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared

    weak var delegate: AuthViewControllerDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination
                    as? WebViewViewController
            else {
                print("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    // MARK: - Private Methods

    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(
            named: "nav_back_button"
        )
        navigationController?.navigationBar.backIndicatorTransitionMaskImage =
            UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationController?.navigationBar.tintColor = .ypBlack
    }
}

// MARK: - Extensions

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()

        oauth2Service.fetchOAuthToken(code: code) { result in
            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success(let tokenResponse):
                OAuth2TokenStorage.shared.token = tokenResponse
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Error fetching token: \(error)")
                self.showAuthErrorAlert()
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

extension AuthViewController {
    func showAuthErrorAlert() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
