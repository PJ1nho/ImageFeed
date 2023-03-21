//
//  Image_FeedTests.swift
//  Image_FeedTests
//
//  Created by Тихтей  Павел on 21.03.2023.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "WebViewController") as! WebViewViewController
    }

}
