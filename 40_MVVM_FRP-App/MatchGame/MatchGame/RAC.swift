//
//  RAC.swift
//
//  This file is based on RAC.swift by:
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//
//  Original source can be found at:
//  https://github.com/ColinEberhardt/ReactiveTwitterSearch/blob/master/ReactiveTwitterSearch/Util/UIKitExtensions.swift
//
//  Modified for educational use by Wolfram Schroers <Dr.Schroers@nua-schroers.de> on 5/30/2016.
//  Released under the MIT license.
//

import Foundation
import ReactiveCocoa
import UIKit

import enum Result.NoError
public typealias NoError = Result.NoError

struct AssociationKey {
    static var hidden: UInt8 = 1
    static var alpha: UInt8 = 2
    static var text: UInt8 = 3
    static var enabled: UInt8 = 4
    static var selectedSegmentIndex: UInt = 5
}

// lazily creates a gettable associated property via the given factory
func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: ()->T) -> T {
    return objc_getAssociatedObject(host, key) as? T ?? {
        let associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        return associatedProperty
        }()
}

func lazyMutableProperty<T>(host: AnyObject, key: UnsafePointer<Void>, setter: T -> (), getter: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key: key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithNext{
                newValue in
                setter(newValue)
        }
        return property
    }
}

extension UIView {
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, key: &AssociationKey.alpha, setter: { self.alpha = $0 }, getter: { self.alpha  })
    }

    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.hidden, setter: { self.hidden = $0 }, getter: { self.hidden  })
    }
}

extension UIControl {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.enabled, setter: { self.enabled = $0 }, getter: { self.enabled  })
    }
}

extension UILabel {
    public var rac_text: MutableProperty<String> {
        return lazyMutableProperty(self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { self.text ?? "" })
    }
}

extension UISegmentedControl {
    public var rac_selectedSegmentIndex: MutableProperty<Int> {
        return lazyMutableProperty(self, key: &AssociationKey.selectedSegmentIndex, setter: { self.selectedSegmentIndex = $0 }, getter: { self.selectedSegmentIndex } )
    }
}

extension UISlider {
    public var rac_sliderValueChangedProducer: SignalProducer<Float, NoError> {
        let sliderSignalProducer = self.rac_signalForControlEvents(.ValueChanged).toSignalProducer()
        return sliderSignalProducer.flatMapError { error in
            return SignalProducer<AnyObject?, NoError>.empty
            }
            .map { slider in Float((slider as! UISlider).value) }
    }
}

extension UISegmentedControl {
    public var rac_segmentedControlValueChangedProducer: SignalProducer<Int, NoError> {
        let segmentedControlSignalProducer = self.rac_signalForControlEvents(.ValueChanged).toSignalProducer()
            return segmentedControlSignalProducer.flatMapError { error in
                return SignalProducer<AnyObject?, NoError>.empty
            }
            .map { segmentedControl in (segmentedControl as! UISegmentedControl).selectedSegmentIndex }
    }
}

extension UITextField {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, key: &AssociationKey.text) {

            self.addTarget(self, action: #selector(self.changed), forControlEvents: UIControlEvents.EditingChanged)

            let property = MutableProperty<String>(self.text ?? "")
            property.producer
                .startWithNext {
                    newValue in
                    self.text = newValue
            }
            return property
        }
    }

    func changed() {
        rac_text.value = self.text ?? ""
    }
}