//
//  SingleMatchView.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/17/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// A single match on screen.
class SingleMatchView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    /// Configure this view (sets background color).
    fileprivate func setup() {
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        // Draw the match body in yellow color.
        UIColor.yellow.set()
        context?.move(to: CGPoint(x: 5, y: 5))
        context?.addLine(to: CGPoint(x: 10, y: 5))
        context?.addLine(to: CGPoint(x: 10, y: 55))
        context?.addLine(to: CGPoint(x: 5, y: 55))
        context!.drawPath(using: .fillStroke)

        // Draw the match head in red color.
        UIColor.red.set()
        let headShape = CGRect(x: 2, y: 0, width: 11, height: 20)
        context!.addEllipse(in: headShape)
        context!.drawPath(using: .fillStroke)
    }
}
