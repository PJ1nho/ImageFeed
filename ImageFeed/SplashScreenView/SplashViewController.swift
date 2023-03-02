//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 07.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let authService = OAuth2Service()
    private let splashSegueIdentifier = "ShowAuthVCSegue"
    private let profileService = ProfileService.shared
    let token = OAuth2TokenStorage().token
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = oAuth2TokenStorage.token
        checkToken(token: token)
    }
    
    private func checkToken(token: String) {
        if !token.isEmpty {
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: splashSegueIdentifier, sender: self)
        }
    }
    
    private func switchTabBar() {
        guard let window = UIApplication.shared.windows.first,
              let tabBarVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController
        else {
            fatalError("Invalid Configuration")
        }
        window.rootViewController = tabBarVC
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == splashSegueIdentifier,
           let navVC = segue.destination as? UINavigationController,
           let vc = navVC.viewControllers.first as? AuthViewController {
            vc.delegate = self
        }
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                print("/n MYLOG: \(profile)")
                ProfileImageService.shared.fetchProfileImageURL(username: profile.loginName.replacingOccurrences(of: "@", with: "")) { _ in }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.switchTabBar()
                }
            case .failure(let error):
                print("/n MYLOG: \(error)")
                self?.showAlert()
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        authService.fetchAuthToken(code: code) { [weak self] result in
            switch result {
            case .success(let token):
                print("/n MYLOG: \(token)")
                DispatchQueue.main.async {
                    self?.oAuth2TokenStorage.token = token
                    self?.switchTabBar()
                }
                self?.fetchProfile(token: token)
            case .failure(let error):
                print("/n MYLOG: \(error)")
                self?.showAlert()
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
}