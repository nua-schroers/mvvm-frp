//
//  SettingsViewModel.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// The view model let's the controller know that something must be done.
protocol SettingsTakeAction: CanPresentDialog {

    /// Return to "Main" screen.
    func returnToMain()

    /// Update the labels, slider values and the segmented control.
    func updateLabelsAndSlidersAndSegControl()
}

/// View model corresponding to the "Settings" screen.
class SettingsViewModel: NSObject {

    // MARK: Private state container and private delegate storage

    /// The private state, the regular `MatchDataContext` is sufficient.
    fileprivate var settingsState: MatchDataContext?

    // MARK: State of the view

    /// The text shown for initial matches.
    var initialMatchSetting: String {
        get {
            let initialCount = (self.settingsState?.initialMatchCount)!
            return NSLocalizedString("Initial number of matches: \(initialCount)", comment: "")
        }
    }

    /// The slider value with the initial match count.
    var initialMatchSliderValue: Float {
        get {
            return Float((self.settingsState?.initialMatchCount)!)
        }
    }

    /// The text shown for maximum matches to remove.
    var removeMaxSetting: String {
        get {
            let removeMax = (self.settingsState?.removeMax)!
            return NSLocalizedString("Maximum number to remove: \(removeMax)", comment: "")
        }
    }

    /// The slider value with maximum matches to remove.
    var removeMaxSliderValue: Float {
        get {
            return Float((self.settingsState?.removeMax)!)
        }
    }

    /// The value for the strategy selector.
    var strategyIndex: Int {
        return (self.settingsState?.strategyIndex)!
    }

    // MARK: VM talks to Controller

    /// Activities are triggered through the delegate, this is how the VM talks to the controller.
    weak var delegate: SettingsTakeAction?

    // MARK: VM talks to other VMs

    /// Activities are handled through the `ReceiveDataContext` protocol, this is how the VM talks to other VMs.
    fileprivate weak var contextDelegate: ReceiveDataContext?

    // MARK: Controller talks to VM

    /// Configure with the context and context delegate.
    func configure(_ context: MatchDataContext,
                   contextDelegate: ReceiveDataContext) {
        self.settingsState = context
        self.contextDelegate = contextDelegate
    }

    /// Handle when the view will appear.
    func viewWillAppear() {
        self.delegate?.updateLabelsAndSlidersAndSegControl()
    }

    /// User taps the "Done" button.
    func userTapsDone() {
        // Inform the other VM of the update.
        self.contextDelegate?.dataContextChanged(self.settingsState!)

        // Trigger the screen transition in the view controller.
        self.delegate?.returnToMain()
    }

    /// User moves the initial match count slider.
    func userMovesInitialMatchCountSlider(_ newCount: Float) {
        self.settingsState?.initialMatchCount = Int(newCount)
        self.delegate?.updateLabelsAndSlidersAndSegControl()
    }

    /// User moves the remove maximum slider.
    func userMovesRemoveMaxSlider(_ newCount: Float) {
        self.settingsState?.removeMax = Int(newCount)
        self.delegate?.updateLabelsAndSlidersAndSegControl()
    }

    /// User changes the strategy selector.
    func userSelectsStrategy(_ newIndex: Int) {
        self.settingsState?.strategyIndex = newIndex
        self.delegate?.updateLabelsAndSlidersAndSegControl()
    }
}
