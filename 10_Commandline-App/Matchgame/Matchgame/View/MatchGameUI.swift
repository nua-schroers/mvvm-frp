//
//  PlayerMove.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// The text-based main UI of the app.
class MatchGameUI {

    /// Print the welcome message at the beginning of the game.
    class func welcome() {
        print("Welcome to the match game\n")
        print("The player removing the last match loses the game")
    }

    /// Query configuration parameters.
    ///
    /// - returns: A tuple of the desired starting number of matches, the maximum number of matches to remove and the desired strategy (1: Dumb, 2: Wild, 3: Smart). Invalid values are returned as 0.
    class func queryConfiguration() -> (Int, Int, Int) {
        print("Starting number of matches: ", terminator:"")
        let initialCount = queryIntNumber()
        print("Maximum number of matches to remove: ", terminator:"")
        let removeMax = queryIntNumber()
        print("Strategy to use (1: Dumb, 2: Wild, 3: Smart): ", terminator:"")
        let strategy = queryIntNumber()

        return (initialCount, removeMax, strategy)
    }

    /// Display the current game state.
    ///
    /// - Parameter count: The current number of matches.
    class func showState(_ count: Int) {
        print("There are \(count) matches")
    }

    /// Query a single user move. The user is queried for input until a valid move is entered.
    ///
    /// - returns: The player move.
    /// - Parameter limit: The maximum number of matches the player may remove.
    class func userMove(_ limit:Int) -> Int {
        var userMove = 0
        var isMoveValid = false

        repeat {
            // Query the user move.
            print("Please enter your move (1..\(limit))", terminator:"")
            userMove = queryIntNumber()

            if (userMove >= 1) && (userMove <= limit) {
                // The move is valid, return it.
                isMoveValid = true
            } else {
                // The move is invalid, inform the user.
                print("This is not a valid move!")
            }
        } while !isMoveValid

        return userMove
    }

    /// Show the number of matches the Mac has taken.
    ///
    /// - Parameter move: The computer's move.
    class func showComputerMove(_ move:Int) {
        print("I have taken \(move) matches")
    }

    /// Print the final message at the end of a run.
    class func byebye() {
        print("I hope to see you soon again")
    }

    // MARK: Private implementation

    /// Query user for an integer number.
    ///
    /// - returns: The number the user has entered or 0 for an invalid input.
    fileprivate class func queryIntNumber() -> Int {
        // Query user input (may return arbitrary data), convert input to a string.
        let userEntry = FileHandle.standardInput.availableData
        let userString = String(data: userEntry,
                                encoding: String.Encoding.utf8) ?? "0"

        // Attempt to convert to a number.
        let userNumber = Int(userString.trimmingCharacters(in: .newlines)) ?? 0
        return userNumber;
    }
}
