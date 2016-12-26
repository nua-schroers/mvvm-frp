//
//  MatchDataContext.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// Accept changes to the data model settings.
protocol ReceiveDataContext: class {

    /// Receive the current settings.
    func dataContextChanged(_ context: MatchDataContext)
}

/// Encapsulates the data context that is exchanged during screen transitions.
struct MatchDataContext {

    /// Initial number of matches.
    var initialMatchCount = 18

    /// Initial removal maximum.
    var removeMax = 3

    /// Initial strategy selector value.
    var strategyIndex = 0
}
