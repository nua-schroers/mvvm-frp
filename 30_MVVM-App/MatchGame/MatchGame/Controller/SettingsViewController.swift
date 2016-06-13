//
//  SettingsViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// View controller of the second screen responsible for the settings.
class SettingsViewController: MVVMViewController, SettingsTakeAction {

    // MARK: The corresponding view model (view first)

    /// The main screen view model.
    var viewModel: SettingsViewModel

    // MARK: Lifecycle/workflow management

    required init?(coder aDecoder: NSCoder) {
        self.viewModel = SettingsViewModel()
        super.init(coder: aDecoder)
        self.viewModel.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }

    /// Called by the main game screen view controller to configure this controller.
    ///
    /// This controller uses the information to configure the view model.
    func configure(context: MatchDataContext,
                   contextDelegate: ReceiveDataContext) {
        self.viewModel.configure(context, contextDelegate: contextDelegate)
    }

    // MARK: User Interface

    /// User taps the "Done" button.
    @IBAction func userTapsDone(sender: AnyObject) {
        self.viewModel.userTapsDone()
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
        self.viewModel.userMovesInitialMatchCountSlider(self.initivalMatchCountSlider.value)
    }

    /// Reaction to moving the remove maximum slider.
    @IBAction func userChangesRemoveMaxCount(sender: AnyObject) {
        self.viewModel.userMovesRemoveMaxSlider(self.removeMaxSlider.value)
    }

    /// Reaction to picking a selection on the segmented control.
    @IBAction func userSelectsSegmentedControl(sender: AnyObject) {
        self.viewModel.userSelectsStrategy(self.strategySelector.selectedSegmentIndex)
    }

    // MARK: SettingsTakeAction

    /// Trigger the screen transition back the main screen (handled by the primary game view controller).
    func returnToMain() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /// Update the UI elements.
    func updateLabelsAndSlidersAndSegControl() {
        self.initialMatchCountLabel.text = self.viewModel.initialMatchSetting
        self.removeMaxLabel.text = self.viewModel.removeMaxSetting
        self.initivalMatchCountSlider.value = self.viewModel.initialMatchSliderValue
        self.removeMaxSlider.value = self.viewModel.removeMaxSliderValue
        self.strategySelector.selectedSegmentIndex = self.viewModel.strategyIndex
    }
}
