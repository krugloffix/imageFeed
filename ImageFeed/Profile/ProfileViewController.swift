import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerStackView = UIStackView()
        let profileImage = UIImage(systemName: "person.crop.circle.fill")
        let imageView = UIImageView(image: profileImage)
        let exitButton = UIButton.systemButton(
            with: .exit,
            target: self,
            action: #selector(Self.didTapButton)
        )

        let infoStackView = UIStackView()
        let profileName = UILabel()
        let profileEmail = UILabel()
        let profileDescription = UILabel()

        view.addSubview(headerStackView)
        view.addSubview(infoStackView)

        headerStackView.axis = .horizontal
        headerStackView.alignment = .center
        headerStackView.distribution = .equalSpacing
        headerStackView.addArrangedSubview(imageView)
        headerStackView.addArrangedSubview(exitButton)

        infoStackView.addArrangedSubview(profileName)
        infoStackView.addArrangedSubview(profileEmail)
        infoStackView.addArrangedSubview(profileDescription)

        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 32
        ).isActive = true
        headerStackView.leftAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leftAnchor,
            constant: 16
        ).isActive = true
        headerStackView.rightAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.rightAnchor,
            constant: -24
        ).isActive = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.tintColor = .ypGray

        exitButton.tintColor = .ypRed
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 24).isActive = true

        infoStackView.axis = .vertical
        infoStackView.spacing = 8

        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.topAnchor.constraint(
            equalTo: headerStackView.bottomAnchor,
            constant: 8
        ).isActive = true
        infoStackView.leftAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leftAnchor,
            constant: 16
        ).isActive = true
        infoStackView.rightAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.rightAnchor,
            constant: -16
        ).isActive = true

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

    @objc
    private func didTapButton() {}
}
