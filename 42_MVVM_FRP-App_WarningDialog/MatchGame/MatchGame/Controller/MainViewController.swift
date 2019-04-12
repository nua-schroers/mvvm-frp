//
//  ViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/26/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// The view controller of the first screen responsible for the game.
class MainViewController: MVVMViewController {

    // MARK: The corresponding view model (view first)

    /// The main screen view model.
    var viewModel = MainViewModel()

    // MARK: Lifecycle/workflow management

    override func viewDidLoad() {
        super.viewDidLoad()

        // Data bindings: wire up the label texts.
        self.gameStateLabel.rac_text <~ self.viewModel.gameState
        self.moveReportLabel.rac_text <~ self.viewModel.moveReport

        // Wire up the buttons to the view model actions.
        self.takeOneButton.addTarget(self.viewModel.takeOneAction, action: CocoaAction<Any>.selector, for: .touchUpInside)
        self.takeTwoButton.addTarget(self.viewModel.takeTwoAction, action: CocoaAction<Any>.selector, for: .touchUpInside)
        self.takeThreeButton.addTarget(self.viewModel.takeThreeAction, action: CocoaAction<Any>.selector, for: .touchUpInside)
        self.infoButton.addTarget(self.viewModel.infoButtonAction, action: CocoaAction<Any>.selector, for: .touchUpInside)

        // Wire up the button "enabled" states.
        self.takeTwoButton.rac_enabled <~ self.viewModel.buttonTwoEnabled
        self.takeThreeButton.rac_enabled <~ self.viewModel.buttonThreeEnabled

        // Wire up the match view activities (reset and remove matches with animation).
        self.viewModel.resetMatchView.producer.startWithValues { (count) in
            self.matchPileView.setMatches(count)
        }
        self.viewModel.removeFromMatchView.producer.skip(first: 1).startWithValues { (count) in
            self.matchPileView.removeMatches(count)
        }

        // Handle screen transitions when requested.
        let transitionSubscriber = Signal<Void, NoError>.Observer(value: { self.transitionToSettings() } )
        viewModel.transitionSignal.observe(transitionSubscriber)

        // Handle dialogs.
        self.commonBindings(self.viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Direct method call when view appears.
        self.viewModel.viewWillAppear()
    }

    // MARK: User Interface

    /// The label at the top displaying the current game state.
    @IBOutlet weak var gameStateLabel: UILabel!

    /// The move report label beneath the game state label.
    @IBOutlet weak var moveReportLabel: UILabel!

    /// The graphical match pile.
    @IBOutlet weak var matchPileView: MatchPileView!

    /// The "Take 1" button.
    @IBOutlet weak var takeOneButton: UIButton!

    /// The "Take 2" button.
    @IBOutlet weak var takeTwoButton: UIButton!

    /// The "Take 3" button.
    @IBOutlet weak var takeThreeButton: UIButton!

    /// The "Info" button.
    @IBOutlet weak var infoButton: UIButton!

    // MARK: Private

    fileprivate func transitionToSettings() {
        // Instantiate the settings screen view controller and configure the UI transition.
        let settingsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsController.modalPresentationStyle = .currentContext
        settingsController.modalTransitionStyle = .flipHorizontal

        // Establish VM<->VM bindings.
        self.viewModel.configure(settingsController.viewModel)

        // Perform the transition.
        self.present(settingsController,
                                   animated: true,
                                   completion: nil)
    }
}

