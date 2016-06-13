//
//  MVVMViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit
import ReactiveCocoa

/// View controller which implements a dialog.
///
/// Such a base class should always be used for common/shared functionality in MVVM.
class MVVMViewController: UIViewController {

    /// Establish bindings common to all view models (currently only dialog handling).
    func commonBindings(viewModel: PresentDialog?) {
        if let canPresentDialog = viewModel as PresentDialog! {
            let dialogSubscriber = Observer<DialogContext, NoError>(next: { self.presentDialog($0) } )
            canPresentDialog.dialogSignal.observe(dialogSubscriber)
        }
    }

    // MARK: Private

    /// Present a dialog and handle the user response.
    private func presentDialog(context: DialogContext) {
        let messageController = UIAlertController(title: context.title,
                                                  message: context.message,
                                                  preferredStyle: .Alert)

        // Add primary button.
        let buttonResponse = UIAlertAction(title: context.okButtonText,
                                           style: .Default) { (_) in
                                               context.action()
        }
        messageController.addAction(buttonResponse)

        // Add secondary/cancel button if requested.
        if context.hasCancel {
            messageController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                                      style: .Cancel,
                                                      handler: nil))
        }

        self.presentViewController(messageController,
                                   animated: true,
                                   completion: nil)
    }
}
