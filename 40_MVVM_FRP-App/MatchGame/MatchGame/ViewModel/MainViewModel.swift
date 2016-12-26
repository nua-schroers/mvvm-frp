//
//  MainViewModel.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// View model corresponding to the "Main" game screen.
class MainViewModel: NSObject, PresentDialog {

    // MARK: The data model (a new home!)

    /// Data model for the game state.
    fileprivate var reactiveModel = ReactiveModel()

    // MARK: VM -> Controller communication (state of the view and signals)

    /// The text shown as game state.
    var gameState = MutableProperty("")

    /// The text shown as move report.
    var moveReport = MutableProperty("")

    /// Request to reset the match pile view to a given number of matches.
    var resetMatchView = MutableProperty(18)

    /// Request to remove a certain number of matches from the match pile view.
    var removeFromMatchView = MutableProperty(0)

    /// Enabled-state of "Take 2" button.
    var buttonTwoEnabled = MutableProperty(false)

    /// Enabled-state of "Take 2" button.
    var buttonThreeEnabled = MutableProperty(false)

    /// Request to present a dialog.
    var dialogSignal: Signal<DialogContext, NoError>

    /// Request to transition to the settings screen.
    var transitionSignal: Signal<Void, NoError>

    // MARK: Controller -> VM communication

    /// Taps on the buttons.
    var takeOneAction: CocoaAction<Any>!
    var takeTwoAction: CocoaAction<Any>!
    var takeThreeAction: CocoaAction<Any>!
    var infoButtonAction: CocoaAction<Any>!

    /// Handle when the view will appear.
    func viewWillAppear() {
        self.startNewGame()
    }

    // MARK: VM -> VM communication

    /// Configure the communication with the settings view model declaratively.
    func configure(_ dataContextViewModel: CanSupplyDataContext) {
        // Set initial values.
        dataContextViewModel.initialMatchSliderValue.value = Float(self.reactiveModel.initialCount.value)
        dataContextViewModel.removeMaxSliderValue.value = Float(self.reactiveModel.removeMax.value)
        let strategyIndex:Int
        switch self.reactiveModel.strategy.value {
        case .dumb:
            strategyIndex = 0
        case .wild:
            strategyIndex = 1
        default:
            strategyIndex = 2
        }
        dataContextViewModel.strategyIndex.value = strategyIndex

        // Establish data bindings.
        self.reactiveModel.initialCount <~ dataContextViewModel.initialMatchSliderValue.producer.map { Int($0) }
        self.reactiveModel.removeMax <~ dataContextViewModel.removeMaxSliderValue.producer.map { Int($0) }
        self.reactiveModel.strategy <~ dataContextViewModel.strategyIndex.producer.map({ (index) -> MatchModel.Strategy in
            switch (index) {
            case 0:
                return .dumb
            case 1:
                return .wild
            default:
                return .smart
            }
        })
    }

    // MARK: Declarative init

    /// Designated initializer. Note that the implementation is mostly declarative!
    override init() {
        // Set up capability to submit dialog requests.
        let (signalForDialog, observerForDialog) = Signal<DialogContext, NoError>.pipe()
        self.dialogSignal = signalForDialog
        self.dialogObserver = observerForDialog

        // Set up capability to submit screen transition request.
        let (signalForTransition, observerForTransition) = Signal<Void, NoError>.pipe()
        self.transitionSignal = signalForTransition
        self.transitionObserver = observerForTransition

        super.init()

        // Data binding: Update label texts and button enabled state based on data model.
        self.gameState <~ self.reactiveModel.matchCount.producer.map { self.prettyMatchString($0) }
        self.buttonTwoEnabled <~ self.reactiveModel.userLimit.producer.map { return $0 > 1 }
        self.buttonThreeEnabled <~ self.reactiveModel.userLimit.producer.map { return $0 > 2 }

        // Set up button responses.
        let takeOneRACAction = Action<Void, Void, NoError> {
            self.userMove(1)
            return SignalProducer.empty
        }
        let takeTwoRACAction = Action<Void, Void, NoError>(enabledIf: self.buttonTwoEnabled, {
            self.userMove(2)
            return SignalProducer.empty
        })
        let takeThreeRACAction = Action<Void, Void, NoError>(enabledIf: self.buttonThreeEnabled, {
            self.userMove(3)
            return SignalProducer.empty
        })
        let takeInfoRACAction = Action<Void, Void, NoError> {
            self.transitionObserver.send(value: Void())
            return SignalProducer.empty
        }
        self.takeOneAction = CocoaAction(takeOneRACAction, input: ())
        self.takeTwoAction = CocoaAction(takeTwoRACAction, input: ())
        self.takeThreeAction = CocoaAction(takeThreeRACAction, input: ())
        self.infoButtonAction = CocoaAction(takeInfoRACAction, input: ())
    }

    // MARK: Internal helpers

    fileprivate var dialogObserver: Observer<DialogContext, NoError>
    fileprivate var transitionObserver: Observer<Void, NoError>

    /// Return a number of matches with proper unit.
    fileprivate func prettyMatchString(_ count:Int) -> String {
        switch count {
        case 1:
            return NSLocalizedString("1 match", comment: "")
        default:
            return String(format: NSLocalizedString("%d matches", comment: ""), count)
        }
    }

    /// Start a new game.
    fileprivate func startNewGame() {
        // Handle the data model.
        self.reactiveModel.restart()

        // Handle the state of the view that shall be shown.
        self.moveReport.value = NSLocalizedString("Please start", comment: "")
        self.resetMatchView.value = self.reactiveModel.matchCount.value
    }

    /// End the current game.
    fileprivate func gameOver(_ message:String) {
        self.dialogObserver.send(value: DialogContext(title: NSLocalizedString("The game is over", comment: ""),
                                                      message: message,
                                                      okButtonText: NSLocalizedString("New game", comment: ""),
                                                      action: { self.startNewGame() },
                                                      hasCancel: false))
    }

    /// Execute a user move.
    fileprivate func userMove(_ count:Int) {
        // Update the data model.
        self.reactiveModel.performUserMove(count)

        // Update the match pile UI.
        self.removeFromMatchView.value = count

        // Check if the user lost.
        if self.reactiveModel.isGameOver.value {
            // The user has lost.
            self.gameOver(NSLocalizedString("You have lost", comment: ""))
        } else {
            // The computer moves.
            let computerMove = self.reactiveModel.performComputerMove()

            // Update the match pile UI again.
            self.removeFromMatchView.value = computerMove

            // Check if the computer lost.
            if self.reactiveModel.isGameOver.value {
                // The computer lost.
                self.gameOver(NSLocalizedString("I have lost", comment: ""))
            } else {
                // Update the UI again (print the computer move).
                self.moveReport.value = String(format: NSLocalizedString("I remove %@", comment: ""),
                                               self.prettyMatchString(computerMove))
            }
        }
    }
    
}
