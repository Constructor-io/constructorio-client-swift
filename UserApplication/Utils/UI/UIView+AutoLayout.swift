//
//  UIView+AutoLayout.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

extension UIView {
    func addSubviewToFit(_ v: UIView, spacing: CGFloat = 0) {
        if(v.superview != self) {
            if v.superview != nil {
                v.removeFromSuperview()
            }
            self.addSubview(v)
        }

        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1.0, constant: -spacing))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: v, attribute: .bottom, multiplier: 1.0, constant: spacing))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: v, attribute: .leading, multiplier: 1.0, constant: -spacing))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: v, attribute: .trailing, multiplier: 1.0, constant: spacing))

        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }

    func pinEqualFrame(view1: UIView, toView view2: UIView) {
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: view2, attribute: .width, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: .height, relatedBy: .equal, toItem: view2, attribute: .height, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: .leading, relatedBy: .equal, toItem: view2, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .top, multiplier: 1.0, constant: 0.0))
    }

    func setFixedWidth(_ width: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }

    func setFixedHeight(_ height: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }

    func pinViewToLeft(_ v: UIView) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: v, attribute: .leading, multiplier: 1.0, constant: 0.0))

        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()

    }

    func pinViewToRight(_ v: UIView, distance: CGFloat = 0) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: v, attribute: .trailing, multiplier: 1.0, constant: 0.0))

        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }

    func pinViewToTop(_ v: UIView) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1.0, constant: 0.0))

        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }

    func pinViewToTop(_ v: UIView, withHeight height: CGFloat) {
        if(v.superview == nil || v.superview != self) {
            v.removeFromSuperview()
            self.addSubview(v)
        }

        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: v, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: v, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))

        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
    }

    func pinViewToBottom(_ v: UIView, withBottomDistance bottom: CGFloat, withHeight height: CGFloat?) {
        if(v.superview == nil || v.superview != self) {
            v.removeFromSuperview()
            self.addSubview(v)
        }

        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: v, attribute: .bottom, multiplier: 1.0, constant: bottom))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: v, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: v, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        if let h = height {
            self.addConstraint(NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: h))
        }

        self.setNeedsDisplay()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()

    }

    func pinViewToBottom(_ v: UIView, withHeight height: CGFloat?) {
        self.pinViewToBottom(v, withBottomDistance: 0, withHeight: height)
    }

    func pinViewToBottom(_ v: UIView) {
        self.pinViewToBottom(v, withBottomDistance: 0, withHeight: nil)
    }

    func pin(_ view1: UIView, attr: NSLayoutConstraint.Attribute, view2: UIView, attr2: NSLayoutConstraint.Attribute, spacing: CGFloat = 0.0, multiplier: CGFloat = 1.0) {
        self.addConstraint(NSLayoutConstraint(item: view1, attribute: attr, relatedBy: .equal, toItem: view2, attribute: attr2, multiplier: multiplier, constant: spacing))
    }

    func pinHorizontal(_ left: UIView, right: UIView, withSpacing spacing: CGFloat = 0) {
        self.addConstraint(NSLayoutConstraint(item: left, attribute: .trailing, relatedBy: .equal, toItem: right, attribute: .leading, multiplier: 1.0, constant: -spacing))
    }

    @discardableResult func pinVertical(_ bottomView: UIView, topView: UIView, withSpacing spacing: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: bottomView, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: spacing)
        self.addConstraint(constraint)
        return constraint
    }

    // MARK: Unsafe (doesn't check whether the view has a parent)

    @discardableResult func pinAspectRatio(ratio: CGFloat) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: ratio, constant: 0)
        self.addConstraint(c)
        return c
    }

    @discardableResult func pinSubviewsTrailing(_ view1: UIView, view2: UIView, distance: CGFloat = 0) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: view2, attribute: .trailing, relatedBy: .equal, toItem: view1, attribute: .trailing, multiplier: 1.0, constant: distance)
        self.addConstraint(c)
        return c
    }

    @discardableResult func centerVertical(_ view1: UIView, view2: UIView) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: view1, attribute: .centerY, relatedBy: .equal, toItem: view2, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraint(c)
        return c
    }

    @discardableResult func pinTop(_ toView: UIView, distance: CGFloat = 0) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: toView, attribute: .top, multiplier: 1.0, constant: -distance)
        self.superview!.addConstraint(c)
        return c
    }

    @discardableResult func pinToSuperviewRight(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview!, attribute: .trailing, multiplier: 1.0, constant: -distance)
        self.superview!.addConstraint(c)
        return c
    }

    @discardableResult func pinToSuperviewLeft(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview!, attribute: .leading, multiplier: 1.0, constant: distance)
        self.superview!.addConstraint(c)
        return c
    }

    @discardableResult func pinToSuperviewBottom(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview!, attribute: .bottom, multiplier: 1.0, constant: -distance)
        self.superview!.addConstraint(c)
        return c
    }

    @discardableResult func pinToSuperviewTop(_ distance: CGFloat = 0) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview!, attribute: .top, multiplier: 1.0, constant: distance)
        self.superview!.addConstraint(c)
        return c
    }

    @discardableResult func pinCenterXToSuperview() -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.superview!.addConstraint(c)
        return c
    }

    @discardableResult func pinWidth(_ width: CGFloat) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        self.addConstraint(c)
        return c
    }

    @discardableResult func pinHeight(_ height: CGFloat) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        self.addConstraint(c)
        return c
    }

    @discardableResult func centerInSuperviewHorizontal() -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self.superview!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.superview!.addConstraint(c)
        return c
    }

    @discardableResult func centerInSuperviewVertical() -> NSLayoutConstraint {
        let c = NSLayoutConstraint(item: self.superview!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        self.superview!.addConstraint(c)
        return c
    }
}
