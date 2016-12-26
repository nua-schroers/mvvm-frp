//
//  MatchPileView.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/17/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// The match pile on the screen.
class MatchPileView: UIView {

    /// Number of currently visible matches.
    fileprivate var visibleMatches: Int = 0

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

    /// Set a fixed number of matches. Abort animations if needed.
    func setMatches(_ matchNumber: Int) {
        // Remove all currently visible/animating matches.
        let oldMatches = self.subviews
        for match in oldMatches {
            match.removeFromSuperview()
        }

        let matchesPerRow = 10
        let rows = matchNumber / matchesPerRow
        let matchesInLastRow = matchNumber - (rows * matchesPerRow)

        // Draw all rows up to the last one.
        for row in 0..<rows {
            for column in 0..<matchesPerRow {
                let position = CGRect(x: CGFloat(10 + column * 30),
                        y: CGFloat(0 + row * 80),
                        width: 30, height: 80)
                let match = SingleMatchView(frame: position)
                self.addSubview(match)
            }
        }

        // Draw the final row.
        for column in 0..<matchesInLastRow {
            let position = CGRect(x: CGFloat(10 + column * 30),
                    y: CGFloat(0 + rows * 80),
                    width: 30, height: 80)
            let match = SingleMatchView(frame: position)
            self.addSubview(match)
        }

        // Aktuell sichtbare Zahl von Hölzern.
        self.visibleMatches = matchNumber
    }

    /// Remove a given number of matches with animation.
    func removeMatches(_ matchNumber: Int) {
        // All currently registered matches (including animated ones).
        let oldMatches = self.subviews

        // Actual number of matches to remove.
        let actualNumber = (matchNumber > self.visibleMatches) ? self.visibleMatches : matchNumber;

        let rotation = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2))
        for i in 1...actualNumber {
            let lastIndex = self.visibleMatches - i
            let lastVisibleMatch = oldMatches[lastIndex]

            // Duration of rotation and fade transitions (in seconds, random).
            let rotateDuration = 1.0 + 0.1 * Double(arc4random_uniform(11))
            let fadeDuration = 0.5 + 0.1 * Double(arc4random_uniform(16))

            UIView.animate(withDuration: fadeDuration,
                    animations: {
                        () in
                        lastVisibleMatch.alpha = 0.0
                    }, completion: {
                (_: Bool) in
                lastVisibleMatch.removeFromSuperview()
            })
            UIView.animate(withDuration: rotateDuration,
                    animations: {
                        () in
                        lastVisibleMatch.transform = rotation
                    })
        }

        // Finally, reduce the number of visible matches.
        self.visibleMatches = self.visibleMatches - matchNumber
    }
}
