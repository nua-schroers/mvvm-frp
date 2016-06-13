//
//  SettingsViewModel.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit
import ReactiveCocoa

/// View model corresponding to the "Settings" screen.
class SettingsViewModel: NSObject, CanSupplyDataContext {

    // MARK: VM -> Controller communication (state of the view and signals)

    /// The text shown for initial matches.
    var initialMatchSetting = MutableProperty("")

    /// The text shown for maximum matches to remove.
    var removeMaxSetting = MutableProperty("")

    /// Request to handle the "Done" button.
    var doneSignal: Signal<Void, NoError>

    // MARK: CanSupplyDataContext, VM -> VM communication

    var initialMatchSliderValue = MutableProperty<Float>(18.0)
    var removeMaxSliderValue = MutableProperty<Float>(3.0)
    var strategyIndex = MutableProperty(0)

    // MARK: Controller -> VM communication

    /// Tap on the "Done" button.
    var doneAction: CocoaAction!

    // MARK: Declarative init

    /// Designated initializer.
    override init() {
        // Set up the capability for requests to close the settings screen.
        let (signalForDone, observerForDone) = Signal<Void, NoError>.pipe()
        self.doneSignal = signalForDone
        self.doneObserver = observerForDone

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
            self.doneObserver.sendNext()
            return SignalProducer.empty
        }
        self.doneAction = CocoaAction(doneRACAction, input: ())
    }

    // MARK: Private

    private var doneObserver: Observer<Void, NoError>
}
