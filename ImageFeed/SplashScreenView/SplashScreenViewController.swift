//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 07.02.2023.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let authService = OAuth2Service()
    private let splashSegueIdentifier = "ShowAuthVCSegue"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = oAuth2TokenStorage.token
        checkToken(token: token)
    }
    
    private func checkToken(token: String) {
        if !token.isEmpty {
            switchTabBar()
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
    
}

// MARK: - AuthViewControllerDelegate
extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        authService.fetchAutoToken(code: code) { [weak self] result in
            switch result {
            case .success(let token):
                print("/n MYLOG: \(token)")
                DispatchQueue.main.async {
                    self?.oAuth2TokenStorage.token = token
                    self?.switchTabBar()
                }
            case .failure(let error):
                print("/n MYLOG: \(error)")
            }
        }
    }
}
