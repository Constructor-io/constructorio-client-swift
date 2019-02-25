//
//  UIView+FadeInOut.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public extension UIView {
    public func fadeIn(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.alpha = 1.0
        }, completion: completion)
    }

    public func fadeOutAndRemove(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.alpha = 0.0
        }, completion: { [weak self] completed in
            self?.removeFromSuperview()
            completion?(completed)
        })
    }
}
