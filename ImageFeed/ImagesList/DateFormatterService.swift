//
//  DateFormetterService.swift
//  ImageFeed
//
//  Created by Тихтей  Павел on 24.03.2023.
//

import UIKit

class DateFormatterService {
    static let shared = DateFormatterService()
    
    private init() { }
    lazy var responseDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    lazy var imageDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
}
