//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 07.02.2023.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = OAuth2TokenStorage().token
        checkToken(token: token)
    }
    
    private func checkToken(token: String) {
        if !token.isEmpty {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}
