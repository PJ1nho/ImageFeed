//
//  ViewController.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 18.12.2022.
//

import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let photoNames: [String] = Array(0..<20).map{ "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    private let imagesListService = ImagesListService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.selectionStyle = .none
        let nameOfPicture = photoNames[indexPath.row]
        guard let image = UIImage(named: nameOfPicture) else {
            return
        }
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        if indexPath.row % 2 == 0 {
            cell.likeButton.imageView?.image = UIImage(named: "likeActive")
        } else {
            cell.likeButton.imageView?.image = UIImage(named: "likeInactive")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photoNames[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photoNames[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photoNames.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}
