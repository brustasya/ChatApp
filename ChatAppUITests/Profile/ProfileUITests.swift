//
//  ChatAppUITests.swift
//  ChatAppUITests
//
//  Created by Станислава on 10.05.2023.
//

import XCTest

final class ProfileUITests: XCTestCase {

        func testProfileUIExist() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars["tabBar"].buttons["profileIcon"].tap()
        let profileAvatar = app.images["profileImageView"]
        let name = app.staticTexts["nameLabel"]
        let addPhotoButton = app.buttons["addPhotoButton"]
        
        XCTAssert(profileAvatar.waitForExistence(timeout: 2))
        XCTAssert(name.waitForExistence(timeout: 2))
        XCTAssert(addPhotoButton.waitForExistence(timeout: 2))
    }

}
