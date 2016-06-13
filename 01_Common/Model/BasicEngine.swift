//
//  BasicEngine.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// Engine base class, contains basic states required for all actual move engine implementations.
///
/// - Note: This class should only be subclassed and never be instantiated directly.
class BasicEngine {

    /// The MatchPile class with the current board state.
    var pile: MatchPile

    /// Standard initializer.
    ///
    /// - Parameter myPile: The main `MatchPile` data model.
    init(myPile: MatchPile) {
        self.pile = myPile
    }
}
