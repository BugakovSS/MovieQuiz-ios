//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Admin on 07.01.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app:XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        continueAfterFailure = false
    }

   /* override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app = nil
        app.terminate()
    }*/

    func testExample() throws {

        let app = XCUIApplication()
        app.launch()
    }
    
    func testYesButton() throws {
        
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertPresent() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        let alertFinal = app.alerts["Alert"]
        XCTAssertTrue(alertFinal.exists)
        XCTAssertTrue(alertFinal.label == "Этот раунд окончен!")
        XCTAssertTrue(alertFinal.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testDismissAlert() {
        sleep(3)
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        
        sleep(3)
        
        let alert = app.alerts["Alert"]
        
        sleep(3)
        
        alert.buttons.firstMatch.tap()
        
        sleep(5)
        XCTAssertFalse(alert.exists)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
