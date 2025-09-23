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
    private let profileEmail = UILabel()
    private let profileDescription = UILabel()

    private let exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Private Properties

    private let profileImage = UIImage(resource: .profileMockPhoto)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(headerStackView)
        view.addSubview(infoStackView)

        headerStackView.addArrangedSubview(imageView)
        headerStackView.addArrangedSubview(exitButton)

        infoStackView.addArrangedSubview(profileName)
        infoStackView.addArrangedSubview(profileEmail)
        infoStackView.addArrangedSubview(profileDescription)

        imageView.image = profileImage

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
        profileName.text = "Имя профиля"
        profileName.font = .systemFont(ofSize: 23, weight: .bold)
        profileName.textColor = .ypWhite

        profileEmail.text = "Email"
        profileEmail.font = .systemFont(ofSize: 13)
        profileEmail.textColor = .ypGray

        profileDescription.text = "Описание профиля"
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

    // MARK: - Actions

    @objc
    private func didTapButton() {}
}
