//
//  MatchGameUITests.swift
//  MatchGameUITests
//
//  Created by Dr. Wolfram Schroers on 6/21/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import XCTest

class MatchGameUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }

    // MARK: UI workflow test

    /// Play and win a single game with default settings.
    func testConfigureAndPlayGame() {
        let app = XCUIApplication()

        // Assert we are on the main screen and the game is on.
        XCTAssertTrue(app.buttons["More Info"].exists)
        XCTAssertTrue(app.staticTexts["Removing the last match loses the game, use the info button to change settings."].exists)
        XCTAssertTrue(app.staticTexts["18 matches"].exists)

        // Play a game.
        let take1Button = app.buttons["Take 1"]
        let take3Button = app.buttons["Take 3"]
        XCTAssertTrue(take3Button.exists)
        XCTAssertTrue(take1Button.exists)
        XCTAssertTrue(take3Button.enabled)
        XCTAssertTrue(take1Button.enabled)
        take3Button.tap()
        take3Button.tap()
        take3Button.tap()
        take3Button.tap()
        XCTAssertFalse(take3Button.enabled) // Verify that "Take 3" is now disabled.
        XCTAssertTrue(take1Button.enabled)  // But "Take 1" is still enabled.
        take1Button.tap()

        // End the game.
        let newGameButton = app.alerts["The game is over"].collectionViews.buttons["New game"]
        XCTAssertTrue(newGameButton.exists)
        newGameButton.tap()

        // Assert that a new game has started.
        XCTAssertTrue(app.staticTexts["18 matches"].exists)
    }
    
}
