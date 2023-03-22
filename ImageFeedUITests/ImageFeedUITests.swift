//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Тихтей  Павел on 22.03.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    //    func testAuth() throws {
    //        // тестируем сценарий авторизации
    //        app.buttons["Authenticate"].tap()
    //        let webView = app.webViews["UnsplashWebView"]
    //
    //        XCTAssertTrue(webView.waitForExistence(timeout: 5))
    //
    //        let loginTextField = webView.descendants(matching: .textField).element
    //        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
    //
    //        loginTextField.tap()
    //        loginTextField.typeText("paveltihtey@gmail.com")
    //        webView.swipeUp()
    //
    //        let passwordTextField = webView.descendants(matching: .secureTextField).element
    //        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
    //
    //        passwordTextField.tap()
    //        passwordTextField.typeText("Pasha_2003")
    //        webView.swipeUp()
    //
    //        webView.buttons["Login"].tap()
    //
    //        let tablesQuery = app.tables
    //        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
    //
    //        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    //    }
    
//    func testFeed() throws {
//        let tablesQuery = app.tables
//
//        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//        cell.swipeUp()
//
//        sleep(2)
//
//        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
//
//        cellToLike.buttons["like button off"].tap()
//        cellToLike.buttons["like button on"].tap()
//
//        sleep(2)
//
//        cellToLike.tap()
//
//        sleep(2)
//
//        let image = app.scrollViews.images.element(boundBy: 0)
//        // Zoom in
//        image.pinch(withScale: 3, velocity: 1) // zoom in
//        // Zoom out
//        image.pinch(withScale: 0.5, velocity: -1)
//
//        let navBackButtonWhiteButton = app.buttons["nav back button white"]
//        navBackButtonWhiteButton.tap()
    
//    }
    
    func testProfile() throws {
        func testProfile() throws {
            sleep(3)
            app.tabBars.buttons.element(boundBy: 1).tap()
            
            XCTAssertTrue(app.staticTexts["Pavel Tikhtei"].exists)
            XCTAssertTrue(app.staticTexts["@pj1nho"].exists)
            
            app.buttons["logoutButton"].tap()
            
            app.alerts["Пока-пока"].scrollViews.otherElements.buttons["Да"].tap()
        }
    }
}
