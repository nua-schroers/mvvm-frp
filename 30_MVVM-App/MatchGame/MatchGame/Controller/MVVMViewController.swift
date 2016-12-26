//
//  MVVMViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// View controller which implements a dialog.
///
/// Such a base class should always be used for common/shared functionality in MVVM.
class MVVMViewController: UIViewController, CanPresentDialog {

    // MARK: CanPresentDialog
    internal func presentDialog(_ title: String,
                                message: String,
                                okButtonText: String,
                                action: @escaping () -> Void,
                                hasCancel: Bool) {
        let messageController = UIAlertController(title: title,
                                                  message: message,
                                                  preferredStyle: .alert)
        let buttonResponse = UIAlertAction(title: okButtonText,
                                           style: .default) { (_) in
                                            action()
        }
        messageController.addAction(buttonResponse)

        self.present(messageController,
                     animated: true,
                     completion: nil)
    }
}
