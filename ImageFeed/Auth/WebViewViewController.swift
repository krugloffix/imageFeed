import UIKit
import WebKit

// MARK: - Enums

enum WebViewConstants {
    static let unsplashAuthorizeURLString =
        "https://unsplash.com/oauth/authorize"
    static let progressCompleteValue: Double = 1.0
    static let progressEpsilon: Double = 0.0001
}

// MARK: - Protocols

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    )

    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

// MARK: - WebView View Controller

final class WebViewViewController: UIViewController {

    // MARK: - Private UI Properties

    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var webView: WKWebView!

    // MARK: - Public Properties

    weak var delegate: WebViewViewControllerDelegate?

    // MARK: - Private Properties

    private var estimatedProgressObservation: NSKeyValueObservation?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthView()
        updateProgress()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
            changeHandler: { [weak self] _, _ in
                guard let self = self else { return }
                self.updateProgress()
            }
        )
        updateProgress()
    }

    // MARK: - Private Functions

    private func loadAuthView() {
        guard
            var urlComponents = URLComponents(
                string: WebViewConstants.unsplashAuthorizeURLString
            )
        else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope),
        ]

        guard let url = urlComponents.url else {
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)

        updateProgress()
    }

    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden =
            fabs(
                webView.estimatedProgress
                    - WebViewConstants.progressCompleteValue
            ) <= WebViewConstants.progressEpsilon
    }
}

// MARK: - Extensions

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
