//
//  EngineMove.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// Common interface of all move engines for returning the actual move.
protocol EngineMove {

    /// Compute a computer move.
    ///
    /// - returns: The computer's move.
    func computerMove() -> Int;
}
