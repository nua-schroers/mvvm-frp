//
//  MatchGameTests.swift
//  MatchGameTests
//
//  Created by Dr. Wolfram Schroers on 5/26/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import XCTest
import ReactiveSwift
import ReactiveCocoa
@testable import MatchGame

/// Helper class to supply a data context.
class TestHelper: CanSupplyDataContext {
    var initialMatchSliderValue = MutableProperty<Float>(18.0)
    var removeMaxSliderValue = MutableProperty<Float>(3.0)
    var strategyIndex = MutableProperty(0)
}

/// These are data model only tests.
class MatchGameTests: XCTestCase {

    var matchModel = MatchModel()

    // MARK: Data model only

    /// Verify game lost condition.
    func testGameNotLost() {
        matchModel.initialCount = 20
        matchModel.restart()
        XCTAssertFalse(matchModel.isGameOver())
    }

    /// Verify dumb engine.
    func testDumbEngine() {
        matchModel.initialCount = 10
        matchModel.strategy = .dumb
        matchModel.restart()
        matchModel.performUserMove(1)

        XCTAssertEqual(matchModel.performComputerMove(), 1)
        XCTAssertEqual(matchModel.matchCount, 8)
    }

    /// Verify smart engine.
    func testSmartEngine() {
        matchModel.initialCount = 12
        matchModel.strategy = .smart
        matchModel.restart()
        matchModel.performUserMove(1)

        XCTAssertEqual(matchModel.performComputerMove(), 2)
        XCTAssertEqual(matchModel.matchCount, 9)
    }

    // MARK: View model

    /// Test that the "Take 3" is properly disabled when `removeMax` == 2.
    func testTakeThreeIsDisabled() {
        let mainVM = MainViewModel()

        // Assert that initially both buttons are enabled.
        XCTAssertTrue(mainVM.buttonTwoEnabled.value)
        XCTAssertTrue(mainVM.buttonThreeEnabled.value)

        // Change removeMax.
        let dataContextSource = TestHelper()
        mainVM.configure(dataContextSource)
        dataContextSource.removeMaxSliderValue.value = 2.0

        // Assert that now only the "Take 2" button is enabled.
        XCTAssertTrue(mainVM.buttonTwoEnabled.value)
        XCTAssertFalse(mainVM.buttonThreeEnabled.value)

        // Change removeMax.
        dataContextSource.removeMaxSliderValue.value = 1.0

        // Assert that now neither the "Take 2" nor "Take 3" button is enabled.
        XCTAssertFalse(mainVM.buttonTwoEnabled.value)
        XCTAssertFalse(mainVM.buttonThreeEnabled.value)
    }

    /// Play an entire game with default configuration.
    func testPlayAnEntireGame() {
        let mainVM = MainViewModel()

        // Observe the dialog context.
        var dialogContext: DialogContext?
        mainVM.dialogSignal.observe { dialogEvent in
            dialogContext = dialogEvent.value
        }

        // Assert initial state.
        XCTAssertNil(dialogContext)
        XCTAssertEqual(mainVM.gameState.value, "18 matches")

        // Play the game.
        mainVM.takeThreeAction.execute(Void())
        XCTAssertEqual(mainVM.gameState.value, "14 matches")
        XCTAssertEqual(mainVM.moveReport.value, "I remove 1 match")
        mainVM.takeThreeAction.execute(Void())
        mainVM.takeThreeAction.execute(Void())
        mainVM.takeThreeAction.execute(Void())
        XCTAssertEqual(mainVM.gameState.value, "2 matches")
        XCTAssertNil(dialogContext)

        // End the game (user wins).
        mainVM.takeOneAction.execute(Void())
        XCTAssertNotNil(dialogContext)
        XCTAssertEqual(dialogContext!.title, "The game is over")
        XCTAssertEqual(dialogContext!.message, "I have lost")
        XCTAssertEqual(dialogContext!.okButtonText, "New game")
    }

}
