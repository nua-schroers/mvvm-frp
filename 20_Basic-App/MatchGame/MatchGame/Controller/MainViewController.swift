//
//  ViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/26/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// Accept changes to the data model settings.
protocol CanAcceptSettings: class {

    /// Accept the current settings.
    func settingsChanged(strategySelector: Int,
                         initialMatchOunt: Int,
                         removeMax: Int)
}

/// The view controller of the first screen responsible for the game.
class MainViewController: UIViewController, CanAcceptSettings {

    // MARK: Lifecycle/workflow management

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Start a new game.
        self.startNewGame()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "settings" {
            let controller = segue.destinationViewController as! SettingsViewController

            // Set the initial state of the settings screen.
            controller.initialMatchCount = self.matchModel.initialCount
            controller.removeMax = self.matchModel.removeMax
            switch self.matchModel.strategy {
            case .Dumb:
                controller.strategy = 0
            case .Wild:
                controller.strategy = 1
            case .Smart:
                controller.strategy = 2
            }
            controller.delegate = self
        }
    }

    // MARK: CanAcceptSettings

    func settingsChanged(strategySelector: Int,
                         initialMatchOunt: Int,
                         removeMax: Int) {
        self.matchModel.initialCount = initialMatchOunt
        switch strategySelector {
        case 0:
            self.matchModel.strategy = .Dumb
        case 1:
            self.matchModel.strategy = .Wild
        default:
            self.matchModel.strategy = .Smart
        }
        self.matchModel.removeMax = removeMax
    }

    // MARK: Data Model

    /// Data model for the game state.
    var matchModel = MatchModel()

    // MARK: User Interface

    /// The label at the top displaying the current game state.
    @IBOutlet weak var gameStateLabel: UILabel!

    /// The move report label beneath the game state label.
    @IBOutlet weak var moveReportLabel: UILabel!

    /// The graphical match pile.
    @IBOutlet weak var matchPileView: MatchPileView!

    /// The "Take 2" button. It can be disabled if needed.
    @IBOutlet weak var takeTwoButton: UIButton!

    /// The "Take 3" button. It can be disabled if needed.
    @IBOutlet weak var takeThreeButton: UIButton!

    /// Response to user tapping "Take 1".
    @IBAction func userTappedTakeOne(sender: AnyObject) {
        self.userMove(1)
    }

    /// Response to user tapping "Take 2".
    @IBAction func userTappedTakeTwo(sender: AnyObject) {
        self.userMove(2)
    }

    /// Response to user tapping "Take 3".
    @IBAction func userTappedTakeThree(sender: AnyObject) {
        self.userMove(3)
    }

    // MARK: Game flow/controller

    /// - returns: A number of matches with proper unit.
    func prettyMatchString(count:Int) -> String {
        switch count {
        case 1:
            return NSLocalizedString("1 match", comment: "")
        default:
            return String(format: NSLocalizedString("%d matches", comment: ""), count)
        }
    }

    /// Start a new game.
    func startNewGame() {
        // Update the data model.
        self.matchModel.restart()

        // Configure the view.
        self.moveReportLabel.text = NSLocalizedString("Please start", comment: "")
        self.updateGameStateLabel()
        self.updateButtons()
        self.matchPileView.setMatches(self.matchModel.matchCount)
    }

    /// Update the game state label.
    func updateGameStateLabel() {
        self.gameStateLabel.text = prettyMatchString(self.matchModel.matchCount)
    }

    /// Adjust the buttons -- disable "Take 2" and/or "Take 3" when needed.
    func updateButtons() {
        switch min(self.matchModel.matchCount, self.matchModel.removeMax) {
        case 2:
            self.takeTwoButton.enabled = true
            self.takeThreeButton.enabled = false
        case 1:
            self.takeTwoButton.enabled = false
            self.takeThreeButton.enabled = false
        default:
            self.takeTwoButton.enabled = true
            self.takeThreeButton.enabled = true
        }
    }

    /// End a single game.
    func gameOver(message: String) {
        let messageController = UIAlertController(title: NSLocalizedString("The game is over", comment: ""),
                                                  message: message,
                                                  preferredStyle: .Alert)
        let buttonResponse = UIAlertAction(title: NSLocalizedString("New game", comment: ""),
                                           style: .Default) { (_) in
                                            self.startNewGame()
        }
        messageController.addAction(buttonResponse)

        self.presentViewController(messageController,
                                   animated: true,
                                   completion: nil)
    }

    /// Execute a user move.
    func userMove(count: Int) {
        // Update the data model.
        self.matchModel.performUserMove(count)

        // Update the UI.
        self.matchPileView.removeMatches(count)

        // Check if the user lost.
        if self.matchModel.isGameOver() {
            // The user has lost.
            self.gameOver(NSLocalizedString("You have lost", comment: ""))
        } else {
            // The computer moves.
            let computerMove = self.matchModel.performComputerMove()

            // Update the UI.
            self.matchPileView.removeMatches(computerMove)

            // Check if the computer lost.
            if self.matchModel.isGameOver() {
                // The computer lost.
                self.gameOver(NSLocalizedString("I have lost", comment: ""))
            } else {
                // Update the UI again (print the computer move).
                self.moveReportLabel.text = String(format: NSLocalizedString("I remove %@", comment: ""),
                                                   self.prettyMatchString(computerMove))
            }
        }

        // Update the UI once more.
        self.updateGameStateLabel()
        self.updateButtons()
    }

}

