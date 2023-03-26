//
//  ViewController.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 18.12.2022.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var imageListCell = ImagesListCell()
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photoNames: [String] = Array(0..<20).map{ "\($0)" }
    private var photos = [Photo]()
    private var imagesListObserver: NSObjectProtocol?
    private var selectedImage: UIImage?
    private var selectedIndexPath: IndexPath?
    weak var delegate: ImagesListCellDelegate?

    private let imagesListService = ImagesListService()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListObserver = NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.image = selectedImage
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    // MARK: - SetupUI
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.selectionStyle = .none
        let thumbURL = photos[indexPath.row].thumbImageURL
        let createdAt = photos[indexPath.row].createdAt
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: URL(string: thumbURL),
                                   placeholder: UIImage(named: "loadingScreen"))
        guard let createdAt = photos[indexPath.row].createdAt
        else {
            cell.dateLabel.text = ""
            return
        }
        cell.dateLabel.text = DateFormatterService.shared.imageDateFormatter.string(from: createdAt)
    }
    
    //MARK: - Functions
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Не надо", style: .default))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in
            guard let selectedIndexPath = self.selectedIndexPath else { return }
            self.tableView.delegate?.tableView?(self.tableView, didSelectRowAt: selectedIndexPath)
        }))
    }
}

    // MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let photoURL = URL(string: photos[indexPath.row].largeImageURL) else { return }
        self.selectedIndexPath = indexPath
        UIBlockingProgressHUD.show()
        KingfisherManager.shared.retrieveImage(with: photoURL, options: nil, progressBlock: nil, completionHandler: { result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
            }
            switch result {
            case .success(let result):
                self.selectedImage = result.image
                self.performSegue(withIdentifier: self.showSingleImageSegueIdentifier, sender: indexPath)
            case .failure(let error):
                self.showError()
                fatalError()
            }
        })
    }
}

    // MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        self.imageListCell = imageListCell
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            switch result {
            case .success(let isLiked):
                guard let self = self else { return }
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(isLiked)
                }
            case .failure:
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self?.showAlert()
                }
            }
        }
    }
}
