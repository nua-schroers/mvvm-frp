//
//  MatchGameTests.swift
//  MatchGameTests
//
//  Created by Dr. Wolfram Schroers on 5/26/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import XCTest
@testable import MatchGame

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

}
