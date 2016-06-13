//
//  DumbComputerMove.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// Engine with the "dumb" strategy (always takes a single match).
class DumbEngine: BasicEngine, EngineMove {

    // MARK: EngineMove

    func computerMove() -> Int {
        let move = 1
        return move
    }
}
