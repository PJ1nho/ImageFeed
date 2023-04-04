//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 01.04.2023.
//

import Foundation
import Kingfisher

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? {get set}
    func getProfileImageURL()
    func getProfileDetails()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared

    
    func getProfileImageURL() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        view?.updateAvatar(url: url, processor: processor)
    }
    
    func getProfileDetails() {
        let name = profileService.profile?.name
        let loginName = profileService.profile?.loginName
        let bio = profileService.profile?.bio
        view?.updateProfileDetails(name: name, loginName: loginName, bio: bio)
    }
}
