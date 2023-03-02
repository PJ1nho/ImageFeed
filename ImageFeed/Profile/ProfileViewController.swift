import UIKit

final class ProfileViewController: UIViewController {
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let tagName = UILabel()
    let userInformation = UILabel()
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.DidChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
    }
    
    private func setupUI() {
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
        let logOutButton = UIButton.systemButton(with: UIImage(named: "logOutButton")!, target: self, action: .none)
        logOutButton.tintColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            logOutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
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
    
    private func updateProfileDetails() {
        nameLabel.text = profileService.profile?.name
        tagName.text = profileService.profile?.loginName
        userInformation.text = profileService.profile?.bio
    }
}
