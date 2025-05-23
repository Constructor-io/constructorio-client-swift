//
//  UIView+FadeInOut.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

extension UIView {
    func fadeIn(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.alpha = 1.0
        }, completion: completion)
    }

    func fadeOutAndRemove(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.alpha = 0.0
        }, completion: { [weak self] completed in
            self?.removeFromSuperview()
            completion?(completed)
        })
    }
}
