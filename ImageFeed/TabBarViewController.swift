//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 02.03.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController") as? ImagesListViewController else { return }
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.presenter = imagesListPresenter
        
        let profilePresenter = ProfilePresenter()
        let profileViewController = ProfileViewController()
        profileViewController.presenter = profilePresenter
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named:"tab_profile_active"),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
