//
//  FunWithPaintUITests.swift
//  FunWithPaintUITests
//
//  Created by Avra Ghosh on 20/03/18.
//  Copyright © 2018 Avra Ghosh. All rights reserved.
//

import XCTest

class FunWithPaintUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        let loginButton = app.buttons["Login"]
        
        let funWithPaintElementsQuery = app.otherElements.containing(.staticText, identifier:"Fun With Paint")
        let textField = funWithPaintElementsQuery.children(matching: .textField).element
        textField.tap()
        textField.typeText("Admin")
        
        let secureTextField = funWithPaintElementsQuery.children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.tap()
        secureTextField.typeText("Password1@")
        loginButton.tap()
        app.buttons["eraser"].tap()
        app.buttons["Free"].tap()
        app.buttons["Oval"].tap()
        app.buttons["Rect"].tap()
        app.buttons["roundrect"].tap()
        app.buttons["line"].tap()
        app.buttons["circle 1"].tap()
        app.buttons["square"].tap()
        
        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        let element = element2.children(matching: .other).element(boundBy: 3)
        element.children(matching: .button).element(boundBy: 0).tap()
        element.children(matching: .button).element(boundBy: 1).tap()
        element.children(matching: .button).element(boundBy: 2).tap()
        element.children(matching: .button).element(boundBy: 3).tap()
        element.children(matching: .button).element(boundBy: 4).tap()
        element.children(matching: .button).element(boundBy: 5).tap()
        element.children(matching: .button).element(boundBy: 6).tap()
        element.children(matching: .button).element(boundBy: 7).tap()
        element.children(matching: .button).element(boundBy: 8).tap()
        element.children(matching: .button).element(boundBy: 9).tap()
        element2.children(matching: .other).element(boundBy: 2)/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeDown()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["trashbin"].tap()
        
    }
    
}
