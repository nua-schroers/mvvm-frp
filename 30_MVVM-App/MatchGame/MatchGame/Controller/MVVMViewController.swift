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
    func presentDialog(title: String,
                       message: String,
                       okButtonText: String,
                       action: () -> Void,
                       hasCancel: Bool) {

        let messageController = UIAlertController(title: title,
                                                  message: message,
                                                  preferredStyle: .Alert)
        let buttonResponse = UIAlertAction(title: okButtonText,
                                           style: .Default) { (_) in
                                               action()
                                           }
        messageController.addAction(buttonResponse)

        self.presentViewController(messageController,
                                   animated: true,
                                   completion: nil)
    }

}
