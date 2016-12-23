//
//  ViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/26/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// The view controller of the first screen responsible for the game.
class MainViewController: MVVMViewController, MainTakeAction {

    // MARK: The corresponding view model (view first)

    /// The main screen view model.
    var viewModel: MainViewModel

    // MARK: Lifecycle/workflow management

    required init?(coder aDecoder: NSCoder) {
        self.viewModel = MainViewModel()
        super.init(coder: aDecoder)
        self.viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel.viewWillAppear()
    }

    // MARK: Data Model -- THIS IS NO MORE!

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
    @IBAction func userTappedTakeOne(_ sender: AnyObject) {
        self.viewModel.userTappedTake(1)
    }

    /// Response to user tapping "Take 2".
    @IBAction func userTappedTakeTwo(_ sender: AnyObject) {
        self.viewModel.userTappedTake(2)
    }

    /// Response to user tapping "Take 3".
    @IBAction func userTappedTakeThree(_ sender: AnyObject) {
        self.viewModel.userTappedTake(3)
    }

    /// Response to user tapping "Info".
    @IBAction func userTappedInfo(_ sender: AnyObject) {
        self.viewModel.userTappedInfo()
    }

    // MARK: MainTakeAction

    func transitionToSettings() {
        // Instantiate the settings screen view controller and configure the UI transition.
        let settingsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsController.modalPresentationStyle = .currentContext
        settingsController.modalTransitionStyle = .flipHorizontal

        // Set the data context.
        settingsController.configure(self.viewModel.createContext(),
                                     contextDelegate: self.viewModel)

        // Perform the transition.
        self.present(settingsController,
                                   animated: true,
                                   completion: nil)
    }

    func updateLabelsAndButtonStates() {
        self.gameStateLabel.text = self.viewModel.gameState
        self.moveReportLabel.text = self.viewModel.moveReport
        self.takeTwoButton.isEnabled = self.viewModel.buttonTwoEnabled
        self.takeThreeButton.isEnabled = self.viewModel.buttonThreeEnabled
    }

    func setMatchesInPileView(_ count:Int) {
        self.matchPileView.setMatches(count)
    }

    func removeMatchesInPileView(_ count:Int) {
        self.matchPileView.removeMatches(count)
    }
}

