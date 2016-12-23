//
//  MatchModel.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// The compound data model of the match game.
class MatchModel {

    // MARK: Data types

    /// Enumeration for the three types of supported move engines.
    ///
    /// - Dumb: Always takes a single match.
    /// - Wild: Takes a random number of matches.
    /// - Smart: Perfect play, takes the optimal number of matches.
    enum Strategy {
        case dumb
        case wild
        case smart
    }

    // MARK: Administrative

    /// Standard initializer.
    init() {
        self.engine = DumbEngine(myPile: self.pile)
    }

    // MARK: Game state

    /// Choose an engine based on the selected strategy.
    var strategyType = Strategy.dumb {
        willSet(newStrategy) {
            switch newStrategy {
            case .dumb:
                self.engine = DumbEngine(myPile: self.pile)
            case .wild:
                self.engine = WildEngine(myPile: self.pile)
            case .smart:
                self.engine = SmartEngine(myPile: self.pile)
            }
        }
    }

    /// The currently active strategy.
    var strategy: Strategy {
        get {
            return self.strategyType
        }
        set(newStrategy) {
            self.strategyType = newStrategy
        }
    }

    /// The current number of matches.
    var matchCount: Int {
        get {
            return self.pile.count
        }
    }

    /// The initial count of matches when restarting a game. Must always be larger than `removeMax`.
    var initialCount: Int {
        get {
            return self.pile.initialCount
        }
        set(newInitialCount) {
            assert(newInitialCount > 0,
                "The initial number of matches must be greater than 0")
            assert(newInitialCount > self.pile.removeMax,
                "The initial number of matches must be greater than the removal maximum")

            self.pile.initialCount = newInitialCount
        }
    }

    /// The maximum number of matches that can be removed each move. Must always be larger than 0 and smaller than `initialCount`.
    var removeMax: Int {
        get {
            return self.pile.removeMax
        }
        set(newRemoveMax) {
            assert(newRemoveMax > 0,
                "The maximum removal number must be greater than 0")
            assert(newRemoveMax < self.pile.initialCount,
                "The initial number of matches must be greater than the removal maximum")

            self.pile.removeMax = newRemoveMax
        }
    }

    /// - returns: The current limit of matches the user can take in his move. Returns 0 on the computer's move.
    func userLimit() -> Int {
        return (self.pile.rightToMove == .user) ? self.pile.limit() : 0
    }

    /// - returns: Whether the game is lost.
    func isGameOver() -> Bool {
        return self.pile.isLost()
    }
    
    // MARK: Public methods to manipulate the game state

    /// Restart the game.
    func restart() {
        self.pile.rightToMove = .user
        self.pile.restart()
    }

    /// Compute and perform the computer move.
    ///
    /// - returns: The computer's move.
    func performComputerMove() -> Int {
        assert(self.pile.rightToMove == .computer,
               "This method must only be called when it's the computer's turn to move")

        let move = self.engine.computerMove()
        self.pile.removeMatches(move)
        self.pile.rightToMove = .user
        return move
    }

    /// Perform the user move.
    ///
    /// - Parameter move: The number of matches the user removes.
    func performUserMove(_ move:Int) {
        assert(move <= self.pile.limit(),
               "The user move is invalid and must be validated prior to calling this method")
        assert(self.pile.rightToMove == .user,
               "This method must only be called when it's the user's turn to move")

        self.pile.removeMatches(move)
        self.pile.rightToMove = .computer
    }

    // MARK: Private implementation

    /// The match pile (playing board state).
    fileprivate var pile = MatchPile();

    /// Search engine for the computer move.
    fileprivate var engine: EngineMove
}
