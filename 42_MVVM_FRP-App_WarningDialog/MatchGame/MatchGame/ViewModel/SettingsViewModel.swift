//
//  SettingsViewModel.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// View model corresponding to the "Settings" screen.
class SettingsViewModel: NSObject, CanSupplyDataContext, PresentDialog {

    // MARK: VM -> Controller communication (state of the view and signals)

    /// The text shown for initial matches.
    var initialMatchSetting = MutableProperty("")

    /// The text shown for maximum matches to remove.
    var removeMaxSetting = MutableProperty("")

    /// Request to handle the "Done" button.
    var doneSignal: Signal<Void, NoError>

    /// Request to present a dialog.
    var dialogSignal: Signal<DialogContext, NoError>

    // MARK: CanSupplyDataContext, VM -> VM communication

    var initialMatchSliderValue = MutableProperty<Float>(18.0)
    var removeMaxSliderValue = MutableProperty<Float>(3.0)
    var strategyIndex = MutableProperty(0)

    // MARK: Controller -> VM communication

    /// Tap on the "Done" button.
    var doneAction: CocoaAction<Any>!

    // MARK: Declarative init

    /// Designated initializer.
    override init() {
        // Set up the capability for requests to close the settings screen.
        let (signalForDone, observerForDone) = Signal<Void, NoError>.pipe()
        self.doneSignal = signalForDone
        self.doneObserver = observerForDone

        // Set up capability to submit dialog requests.
        let (signalForDialog, observerForDialog) = Signal<DialogContext, NoError>.pipe()
        self.dialogSignal = signalForDialog
        self.dialogObserver = observerForDialog

        super.init()

        // Establish data bindings for updating the labels.
        self.initialMatchSetting <~ self.initialMatchSliderValue.producer.map {
            NSLocalizedString("Initial number of matches: \(Int($0))", comment: "")
        }
        self.removeMaxSetting <~ self.removeMaxSliderValue.producer.map {
            NSLocalizedString("Maximum number to remove: \(Int($0))", comment: "")
        }

        // Set up the action to handle taps on the "Done" button.
        let doneRACAction = Action<Void, Void, NoError> {
            if self.strategyIndex.value == 2 && self.isForbiddenNumber() {
                self.dialogObserver.send(value: DialogContext(title: NSLocalizedString("You will lose", comment: ""),
                                                              message: NSLocalizedString("With these settings you will definitely lose the next game",
                                                                                         comment: ""),
                                                              okButtonText: NSLocalizedString("I don't care", comment: ""),
                                                              action: { self.doneObserver.send(value: Void()) },
                                                              hasCancel: true))
            } else {
                self.doneObserver.send(value: Void())
            }
            return SignalProducer.empty
        }
        self.doneAction = CocoaAction(doneRACAction, input: ())
    }

    // MARK: Private

    fileprivate var doneObserver: Observer<Void, NoError>

    fileprivate var dialogObserver: Observer<DialogContext, NoError>

    /// - Returns: If the initialCount number is a "forbidden" number.
    func isForbiddenNumber() -> Bool {
        // Forbidden number: Player who moves at this number always loses.
        let currentInitialCount = Int(self.initialMatchSliderValue.value)
        let forbiddenOffset = Int(self.removeMaxSliderValue.value)+1
        let forbiddenNumber = ((currentInitialCount-1)/forbiddenOffset)*forbiddenOffset+1
        
        return currentInitialCount == forbiddenNumber
    }
}
