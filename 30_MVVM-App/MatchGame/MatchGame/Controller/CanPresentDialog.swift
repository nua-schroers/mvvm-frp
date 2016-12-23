//
//  CanPresentDialog.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// Generic view controller functionality for presenting a dialog with a main action.
protocol CanPresentDialog: class {

    /// Present a dialog with a title, a message, a main action and whether it should have a "Cancel" button.
    func presentDialog(_ title: String,
                       message: String,
                       okButtonText: String,
                       action: @escaping () -> Void,
                       hasCancel: Bool)
}
