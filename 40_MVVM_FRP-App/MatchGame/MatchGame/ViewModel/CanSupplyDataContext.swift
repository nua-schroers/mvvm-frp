//
//  CanSupplyDataContext.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/31/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

/// Protocol for VM -> VM communication.
protocol CanSupplyDataContext {

    /// The slider value with the initial match count.
    var initialMatchSliderValue: MutableProperty<Float> { get }

    /// The slider value with maximum matches to remove.
    var removeMaxSliderValue: MutableProperty<Float> { get }

    /// The value for the strategy selector.
    var strategyIndex: MutableProperty<Int> { get }
}
