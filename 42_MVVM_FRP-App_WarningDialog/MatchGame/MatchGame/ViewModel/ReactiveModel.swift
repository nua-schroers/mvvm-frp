//
//  ModelWrapper.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/30/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation
import ReactiveCocoa

/// This class exports the API of the data model to ReactiveCocoa-style mutable properties.
///
/// - Note: This wrapper looks quite "old style". This may be improved/simplified with advanced use of the
/// ReactiveCocoa-API. Althernatively, the data model could be rewritten from scratch with FRP in mind.
class ReactiveModel {

    // MARK: Public API

    /// The current move engine being used.
    var strategy = MutableProperty(MatchModel.Strategy.Dumb)

    /// The current match count.
    var matchCount = MutableProperty(18)

    /// The initial number of matches.
    var initialCount = MutableProperty(18)

    /// The maximum number of matches to remove.
    var removeMax = MutableProperty(3)

    /// The maximum number of matches the user can remove.
    var userLimit = MutableProperty(3)

    /// Indicate whether the game is over or not.
    var isGameOver = MutableProperty(false)

    /// Designated initializer.
    init() {
        self.classicMatchModel = MatchModel()
        self.updateProperties()

        self.strategy.producer.startWithNext { (newStrategy) in
            self.classicMatchModel.strategy = newStrategy
        }
        self.initialCount.producer.startWithNext { (newInitialCount) in
            self.classicMatchModel.initialCount = newInitialCount
        }
        self.removeMax.producer.startWithNext { (newRemoveMax) in
            self.classicMatchModel.removeMax = newRemoveMax
            self.userLimit.value = self.classicMatchModel.userLimit()
        }
    }

    func restart() {
        self.classicMatchModel.restart()
        self.updateProperties()
    }

    func performComputerMove() -> Int {
        let computerMove = self.classicMatchModel.performComputerMove()
        self.updateProperties()
        return computerMove
    }

    func performUserMove(move: Int) {
        self.classicMatchModel.performUserMove(move)
        self.updateProperties()
    }

    // MARK: Private

    /// The data model with the "old" API.
    private var classicMatchModel: MatchModel

    /// Update the properties.
    ///
    /// This could be refactored with KVO, but it will neither make the code easier to read nor to understand.
    private func updateProperties() {
        self.strategy.value     = self.classicMatchModel.strategy
        self.matchCount.value   = self.classicMatchModel.matchCount
        self.initialCount.value = self.classicMatchModel.initialCount
        self.removeMax.value    = self.classicMatchModel.removeMax
        self.userLimit.value    = self.classicMatchModel.userLimit()
        self.isGameOver.value   = self.classicMatchModel.isGameOver()
    }
}

