//
//  GameFlow.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// Controller for the game workflow.
class MatchGameController {

    /// The data model instance.
    var model = MatchModel()

    /// Default configuration values.
    let defaultInitialCount = 18
    let defaultRemoveMax = 3
    let defaultStrategy = MatchModel.Strategy.wild

    /// Main app workflow.
    func play() {

        // Display the welcome message at game launch.
        MatchGameUI.welcome()

        // Configure the starting parameters.
        let configuration = MatchGameUI.queryConfiguration()
        self.model.initialCount = (configuration.0 > 0) ? configuration.0 : defaultInitialCount
        self.model.removeMax = ((configuration.1 > 0 &&
            configuration.1 < configuration.0) ?
                configuration.1 : defaultRemoveMax)
        switch configuration.2 {
        case 1:
            self.model.strategy = MatchModel.Strategy.dumb
        case 2:
            self.model.strategy = MatchModel.Strategy.wild
        case 3:
            self.model.strategy = MatchModel.Strategy.smart
        default:
            self.model.strategy = defaultStrategy
        }
        self.model.restart()

        // Main loop.
        while true {
            MatchGameUI.showState(self.model.matchCount)

            // Query for and perform a valid user move.
            let userLimit = self.model.userLimit()
            let userMove = MatchGameUI.userMove(userLimit)
            self.model.performUserMove(userMove)

            if self.model.isGameOver() {
                print("I'm sorry, you lost")
                break
            }

            // Perform the computer move.
            let macMove = self.model.performComputerMove()
            MatchGameUI.showComputerMove(macMove)

            if self.model.isGameOver() {
                print("Congratulations, you won")
                break
            }
        }

        // Display the final message.
        MatchGameUI.byebye()
    }
}
