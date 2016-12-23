//
//  WildComputerMove.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// Engine with the "wild" strategy (randomly).
class WildEngine: BasicEngine, EngineMove {

    // MARK: EngineMove

    func computerMove() -> Int {
        let moveMax = self.pile.limit()
        let move = randomNumber(upper:moveMax)

        return move
    }

    // MARK: Private implementation

    /// Random number generator.
    ///
    /// - Parameter lower: Lower limit for resulting random number (inclusive, defaults to 1).
    /// - Parameter upper: Upper limit for resulting random number (inclusive, defaults to 3).
    ///                    `upper` must be larger than `lower`.
    /// - returns: An integer random number between `lower` and `upper`.
    fileprivate func randomNumber(_ lower:Int = 1, upper:Int = 3) -> Int {
        assert(upper >= lower,
               "The upper limit must be larger than the lower one")

        let random1 = arc4random_uniform(UInt32(upper - lower + 1))
        let result = lower + Int(random1)

        return result
    }
}
