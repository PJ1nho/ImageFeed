//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 01.04.2023.
//

import Foundation

protocol ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? {get set}
    func fetchNextPage()
    func getPhotos() -> [Photo]
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void)
}

final class ImagesListPresenter: ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService()
    
    func fetchNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func getPhotos() -> [Photo] {
        return imagesListService.photos
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLiked, completion)
    }
}
