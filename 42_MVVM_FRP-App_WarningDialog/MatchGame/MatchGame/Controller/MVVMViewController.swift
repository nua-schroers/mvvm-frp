//
//  MVVMViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// View controller which implements a dialog.
///
/// Such a base class should always be used for common/shared functionality in MVVM.
class MVVMViewController: UIViewController {

    /// Establish bindings common to all view models (currently only dialog handling).
    func commonBindings(_ viewModel: PresentDialog?) {
        if let canPresentDialog = viewModel {
            let dialogSubscriber = Signal<DialogContext, Never>.Observer(value: { self.presentDialog($0) } )
            canPresentDialog.dialogSignal.observe(dialogSubscriber)
        }
    }

    // MARK: Private

    /// Present a dialog and handle the user response.
    fileprivate func presentDialog(_ context: DialogContext) {
        let messageController = UIAlertController(title: context.title,
                                                  message: context.message,
                                                  preferredStyle: .alert)

        // Add primary button.
        let buttonResponse = UIAlertAction(title: context.okButtonText,
                                           style: .default) { (_) in
                                               context.action()
        }
        messageController.addAction(buttonResponse)

        // Add secondary/cancel button if requested.
        if context.hasCancel {
            messageController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                                      style: .cancel,
                                                      handler: nil))
        }

        self.present(messageController,
                                   animated: true,
                                   completion: nil)
    }
}
