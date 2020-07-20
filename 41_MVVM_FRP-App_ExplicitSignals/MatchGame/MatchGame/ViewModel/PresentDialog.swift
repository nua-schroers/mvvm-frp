//
//  CanPresentDialog.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

/// Container describing a dialog handled by `PresentDialog`.
struct DialogContext {

    /// Designated initializer.
    init(title: String,
         message: String,
         okButtonText: String,
         action: @escaping () -> Void = {},
         hasCancel: Bool = false) {
        self.title = title
        self.message = message
        self.okButtonText = okButtonText
        self.action = action
        self.hasCancel =  hasCancel
    }

    /// Dialog title.
    let title: String

    /// Dialog message.
    let message: String

    /// Text of "Ok" button.
    let okButtonText: String

    /// Action to be taken once user taps "Ok".
    let action: () -> Void

    /// Whether or not the dialog has a "Cancel" button.
    let hasCancel: Bool
}

/// Generic view controller functionality for presenting a dialog with a main action.
protocol PresentDialog: class {

    /// Present a dialog with a title, a message, a main action and whether it should have a "Cancel" button.
    var dialogSignal: Signal<DialogContext, Never> { get }
}
