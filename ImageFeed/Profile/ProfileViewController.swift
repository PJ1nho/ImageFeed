import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    func updateAvatar(url: URL, processor: RoundCornerImageProcessor)
    func updateProfileDetails(name: String?, loginName: String?, bio: String?)
}

final class ProfileViewController: UIViewController {
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let tagName = UILabel()
    private let userInformation = UILabel()
    private var logOutButton = UIButton()
    var presenter: ProfilePresenterProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.view = self
        presenter?.getProfileDetails()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.DidChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.getProfileImageURL()
            }
        presenter?.getProfileImageURL()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        self.view.backgroundColor = UIColor(red: 26/255.0, green: 27/255.0, blue: 34/255.0, alpha: 1)
        configureImageView()
        configureNameLabel()
        configureTagName()
        configureUserInformation()
        configureLogOutButton()
        configureConstraints()
    }
    
    private func configureImageView() {
        profileImageView.image = UIImage(named: "Photo")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
    }
    
    private func configureNameLabel() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }
    
    private func configureTagName() {
        tagName.text = "@ekaterina_nov"
        tagName.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        tagName.font = .systemFont(ofSize: 13, weight: .regular)
        tagName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagName)
    }
    
    private func configureUserInformation() {
        userInformation.text = "Hello, world!"
        userInformation.textColor = .white
        userInformation.font = .systemFont(ofSize: 13, weight: .regular)
        userInformation.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userInformation)
    }
    
    private func configureLogOutButton() {
        logOutButton = UIButton.systemButton(with: UIImage(named: "logOutButton")!, target: self, action: .none)
        logOutButton.tintColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            logOutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
        
        logOutButton.addTarget(self, action: #selector(self.logOutClicked), for: .touchUpInside)
        logOutButton.accessibilityIdentifier = "logOutButton"
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            tagName.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            tagName.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            userInformation.topAnchor.constraint(equalTo: tagName.bottomAnchor, constant: 8),
            userInformation.leadingAnchor.constraint(equalTo: tagName.leadingAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc func logOutClicked() {
        showLogOutAlert()
    }
    
    // MARK: - Functions
    
    private func showLogOutAlert() {
        let alert = UIAlertController(title: "Пока-пока", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
            OAuth2TokenStorage().clearToken()
            WebViewViewController.clear()
            let splashViewController = SplashViewController()
            splashViewController.modalPresentationStyle = .fullScreen
            self.present(splashViewController, animated: true)
            return
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { _ in
            return
        }))
        self.present(alert, animated: true)
    }
}

// MARK: - ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol {
    func updateProfileDetails(name: String?, loginName: String?, bio: String?) {
        DispatchQueue.main.async {
            self.nameLabel.text = name
            self.tagName.text = loginName
            self.userInformation.text = bio
        }
    }
    
    func updateAvatar(url: URL, processor: RoundCornerImageProcessor) {
        self.profileImageView.kf.setImage(with: url,
                                          options: [.processor(processor)])
    }
}
