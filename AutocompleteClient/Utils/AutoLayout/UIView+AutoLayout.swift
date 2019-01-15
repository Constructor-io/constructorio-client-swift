//
//  UIView+AutoLayout.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

extension UIViewController {
    public func fitViewInsideLayoutGuides(_ view: UIView) {
        if(view.superview == nil || view.superview != self) {
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
    public func addViewToFit(_ view: UIView) {
        if(view.superview != self) {
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

    public func pinEqualFrame(view1: UIView, toView view2: UIView) {
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: view2, attribute: .width, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: .height, relatedBy: .equal, toItem: view2, attribute: .height, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: .leading, relatedBy: .equal, toItem: view2, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .top, multiplier: 1.0, constant: 0.0))
    }

    public func setFixedWidth(_ width: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }

    public func setFixedHeight(_ height: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }

    public func pinViewToLeft(_ view: UIView) {
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

    public func pinViewToBottom(_ view: UIView, withHeight height: CGFloat?) {
        self.pinViewToBottom(view, withBottomDistance: 0, withHeight: height)
    }

    public func pinViewToBottom(_ view: UIView) {
        self.pinViewToBottom(view, withBottomDistance: 0, withHeight: nil)
    }

    public func pin(_ view1: UIView, attr: NSLayoutAttribute, view2: UIView, attr2: NSLayoutAttribute, spacing: CGFloat = 0.0, multiplier: CGFloat = 1.0) {
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: attr, relatedBy: .equal, toItem: view2, attribute: attr2, multiplier: multiplier, constant: spacing))
    }

    public func pinHorizontal(_ left: UIView, right: UIView, withSpacing spacing: CGFloat = 0) {
        self.addConstraint(NSLayoutConstraint(item: left, attribute: .trailing, relatedBy: .equal, toItem: right, attribute: .leading, multiplier: 1.0, constant: -spacing))
    }

    @discardableResult
    public func pinVertical(_ bottomView: UIView, topView: UIView, withSpacing spacing: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: bottomView, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: spacing)
        self.addConstraint(constraint)
        return constraint
    }

    // MARK: Unsafe (doesn't check whether the view has a parent)

    @discardableResult
    public func pinAspectRatio(ratio: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: ratio, constant: 0)
        self.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func pinSubviewsTrailing(_ view1: UIView, view2: UIView, distance: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view2, attribute: .trailing, relatedBy: .equal, toItem: view1, attribute: .trailing, multiplier: 1.0, constant: distance)
        self.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func centerVertical(_ view1: UIView, view2: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view1, attribute: .centerY, relatedBy: .equal, toItem: view2, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func pinTop(_ toView: UIView, distance: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: toView, attribute: .top, multiplier: 1.0, constant: -distance)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func pinToSuperviewRight(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview!, attribute: .trailing, multiplier: 1.0, constant: -distance)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func pinToSuperviewLeft(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview!, attribute: .leading, multiplier: 1.0, constant: distance)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func pinToSuperviewBottom(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview!, attribute: .bottom, multiplier: 1.0, constant: -distance)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func pinToSuperviewTop(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview!, attribute: .top, multiplier: 1.0, constant: distance)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func pinCenterXToSuperview() -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func pinWidth(_ width: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        self.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func pinHeight(_ height: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        self.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func centerInSuperviewHorizontal() -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self.superview!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.superview!.addConstraint(constraint)
        return constraint
    }

    @discardableResult
    public func centerInSuperviewVertical() -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self.superview!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        self.superview!.addConstraint(constraint)
        return constraint
    }
}
