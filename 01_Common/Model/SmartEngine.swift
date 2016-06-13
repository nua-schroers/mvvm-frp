//
//  SmartComputerMove.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// Engine with the "smart" strategy (perfect play).
class SmartEngine: BasicEngine, EngineMove {

    // MARK: EngineMove

    func computerMove() -> Int {
        // Forbidden number: Player who moves at this number always loses.
        let forbiddenOffset = self.pile.removeMax+1
        let forbiddenNumber = ((self.pile.count-1)/forbiddenOffset)*forbiddenOffset+1

        // Distance to next forbidden number.
        let difference = self.pile.count - forbiddenNumber

        // Perform the move.
        var move: Int
        if difference > 0 {
            // Force the opponent on a forbidden number.
            move = difference
        } else {
            // We are already at a forbidden number, try to delay loss as long as possible.
            move = 1
        }

        return move
    }
}
