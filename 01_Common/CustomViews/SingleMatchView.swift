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
    private func setup() {
        self.backgroundColor = UIColor.clearColor()
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        // Draw the match body in yellow color.
        UIColor.yellowColor().set()
        CGContextMoveToPoint(context, 5, 5)
        CGContextAddLineToPoint(context, 10, 5)
        CGContextAddLineToPoint(context, 10, 55)
        CGContextAddLineToPoint(context, 5, 55)
        CGContextDrawPath(context, .FillStroke)

        // Draw the match head in red color.
        UIColor.redColor().set()
        let headShape = CGRectMake(2, 0, 11, 20)
        CGContextAddEllipseInRect(context, headShape)
        CGContextDrawPath(context, .FillStroke)
    }
}
