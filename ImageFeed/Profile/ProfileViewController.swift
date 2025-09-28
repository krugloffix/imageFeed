import Kingfisher
import UIKit

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let infoStackSpacing: CGFloat = 8
        static let headerStackTopInset: CGFloat = 32
        static let headerStackLeftInset: CGFloat = 16
        static let headerStackRightInset: CGFloat = -24
        static let infoStackTopInset: CGFloat = 8
        static let infoStackLeftInset: CGFloat = 16
        static let infoStackRightInset: CGFloat = -16
        static let exitButtonWidth: CGFloat = 44
        static let exitButtonHeight: CGFloat = 44
        static let imageViewWidth: CGFloat = 70
        static let imageViewHeight: CGFloat = 70
    }

    // MARK: - Private UI Properties

    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.infoStackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .ypGray
        return imageView
    }()

    private let profileName = UILabel()
    private let profileLoginName = UILabel()
    private let profileDescription = UILabel()

    private let exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Private Properties

    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileImageServiceObserverName = ProfileImageService
        .didChangeNotification
    private var profileViewImageServiceObserver: NSObjectProtocol?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()

        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }

        profileViewImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: profileImageServiceObserverName,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        
        updateAvatar()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .ypBlack
        
        view.addSubview(headerStackView)
        view.addSubview(infoStackView)

        headerStackView.addArrangedSubview(imageView)
        headerStackView.addArrangedSubview(exitButton)

        infoStackView.addArrangedSubview(profileName)
        infoStackView.addArrangedSubview(profileLoginName)
        infoStackView.addArrangedSubview(profileDescription)
        
        imageView.layer.cornerRadius = Constants.imageViewHeight / 2

        configureLabels()
        configureExitButton()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.headerStackTopInset
            ),
            headerStackView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: Constants.headerStackLeftInset
            ),
            headerStackView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: Constants.headerStackRightInset
            ),
        ])

        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(
                equalTo: headerStackView.bottomAnchor,
                constant: Constants.infoStackTopInset
            ),
            infoStackView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: Constants.infoStackLeftInset
            ),
            infoStackView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: Constants.infoStackRightInset
            ),
        ])

        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(
                equalToConstant: Constants.exitButtonWidth
            ),
            exitButton.heightAnchor.constraint(
                equalToConstant: Constants.exitButtonHeight
            ),
        ])

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(
                equalToConstant: Constants.imageViewWidth
            ),
            imageView.heightAnchor.constraint(
                equalToConstant: Constants.imageViewHeight
            ),
        ])
    }

    private func configureLabels() {
        profileName.font = .systemFont(ofSize: 23, weight: .bold)
        profileName.textColor = .ypWhite

        profileLoginName.font = .systemFont(ofSize: 13)
        profileLoginName.textColor = .ypGray

        profileDescription.font = .systemFont(ofSize: 13)
        profileDescription.textColor = .ypWhite
    }

    private func configureExitButton() {
        exitButton.setImage(.exit, for: .normal)
        exitButton.addTarget(
            self,
            action: #selector(Self.didTapButton),
            for: .touchUpInside
        )
        exitButton.tintColor = .ypRed
    }

    private func updateProfileDetails(profile: Profile) {
        profileName.text = profile.name
        profileDescription.text = profile.bio ?? ""
        profileLoginName.text = profile.loginName
    }

    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL
        else { return }
        
        let url = URL(string: profileImageURL)
        let placeholder = UIImage(named: "profile_image_placeholder")
        let processor = RoundCornerImageProcessor(cornerRadius: Constants.imageViewHeight / 2)
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.processor(processor)])
    }

    // MARK: - Actions

    @objc
    private func didTapButton() {}
}
