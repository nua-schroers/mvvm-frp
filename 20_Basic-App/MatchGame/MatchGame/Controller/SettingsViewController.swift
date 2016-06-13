//
//  SettingsViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// View controller of the second screen responsible for the settings.
class SettingsViewController: UIViewController {

    // MARK: Settings received from the primary game view controller.

    /// Initial number of matches.
    var initialMatchCount = 18

    /// Initial removal maximum.
    var removeMax = 3

    /// Initial strategy selector value.
    var strategy = 0

    /// Delegate for reporting changes.
    weak var delegate: CanAcceptSettings?

    // MARK: Lifecycle/workflow management

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the initial state with current settings.
        self.initivalMatchCountSlider.value = Float(self.initialMatchCount)
        self.removeMaxSlider.value = Float(self.removeMax)
        self.strategySelector.selectedSegmentIndex = self.strategy

        self.updateLabels()
    }

    // MARK: User Interface

    /// Update the labels on this screen.
    func updateLabels() {
        self.initialMatchCountLabel.text = NSLocalizedString("Initial number of matches: \(self.initialMatchCount)", comment: "")
        self.removeMaxLabel.text = NSLocalizedString("Maximum number to remove: \(self.removeMax)", comment: "")
    }

    /// User taps the "Done" button.
    @IBAction func userTapsDone(sender: AnyObject) {
        // Submit the current settings to the delegate.
        self.delegate?.settingsChanged(self.strategySelector.selectedSegmentIndex,
            initialMatchOunt: self.initialMatchCount,
            removeMax: self.removeMax)

        // Transition back to primary game screen.
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /// Label for initial match count.
    @IBOutlet weak var initialMatchCountLabel: UILabel!

    /// Slider for initial match count.
    @IBOutlet weak var initivalMatchCountSlider: UISlider!

    /// Label for remove maximum count.
    @IBOutlet weak var removeMaxLabel: UILabel!

    /// Slider for remove maximum count.
    @IBOutlet weak var removeMaxSlider: UISlider!

    /// Segmented control for strategy selection.
    @IBOutlet weak var strategySelector: UISegmentedControl!

    /// Reaction to moving the initial count slider.
    @IBAction func userChangesInitialMatchCount(sender: AnyObject) {
        self.initialMatchCount = Int(self.initivalMatchCountSlider.value)
        self.updateLabels()
    }

    /// Reaction to moving the remove maximum slider.
    @IBAction func userChangesRemoveMaxCount(sender: AnyObject) {
        self.removeMax = Int(self.removeMaxSlider.value)
        self.updateLabels()
    }
}
