//
//  UIView+AutoLayout.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

extension UIViewController {
    func fitViewInsideLayoutGuides(_ view: UIView) {
        if view.superview == nil || view.superview != self {
            view.removeFromSuperview()
            self.view.addSubview(view)
        }

        self.view.pinViewToLeft(view)
        self.view.pinViewToRight(view)
        self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0))

    }
}

extension UIView {
    func addViewToFit(_ view: UIView) {
        if view.superview != self {
            if view.superview != nil {
                view.removeFromSuperview()
            }
            self.addSubview(view)
        }

        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))

        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }

    func pinViewToLeft(_ view: UIView) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))

        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()

    }

    func pinViewToRight(_ view: UIView, distance: CGFloat = 0) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))

        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }

    @discardableResult
    func pinToSuperviewRight(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview!, attribute: .trailing, multiplier: 1.0, constant: -distance)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    func pinToSuperviewLeft(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview!, attribute: .leading, multiplier: 1.0, constant: distance)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    func pinToSuperviewBottom(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview!, attribute: .bottom, multiplier: 1.0, constant: -distance)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    func pinToSuperviewTop(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview!, attribute: .top, multiplier: 1.0, constant: distance)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    func centerInSuperviewVertical() -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self.superview!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        self.superview!.addConstraint(constraint)
        return constraint
    }
}
