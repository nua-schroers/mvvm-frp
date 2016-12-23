//
//  MatchPile.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// A pile of matches, stores the number of matches and evaluates the current game state.
class MatchPile {

    // MARK: Data types

    /// Enumeration for the current right to move.
    ///
    /// - User: The user moves next.
    /// - Computer: The computer moves next.
    enum RightToMove {
        case user
        case computer
    }

    // MARK: Board state

    /// Initial number of matches.
    var initialCount = 18

    /// Current number of matches.
    var count = 18

    /// Maximum number of matches that may be removed each move.
    var removeMax = 3

    /// The current right to move state.
    var rightToMove: RightToMove = .user

    // MARK: Public methods to manipulate the board state

    /// Restart the game.
    func restart() {
        self.count = self.initialCount
    }

    /// Remove a certain number of matches.
    ///
    /// - Parameter number: Number of matches to remove.
    func removeMatches(_ number: Int) {
        if self.count > number {
            self.count -= number
        } else {
            self.count = 0
        }
    }

    /// - returns: The maximum number of matches a player may remove.
    func limit() -> Int {
        return (self.count < removeMax) ? self.count : self.removeMax
    }

    /// - returns: Whether the game is lost.
    func isLost() -> Bool {
        return (self.count == 0)
    }
}
