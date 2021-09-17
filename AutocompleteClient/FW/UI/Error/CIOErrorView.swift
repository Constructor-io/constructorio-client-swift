//
//  CIOErrorView.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

/**
 Conform to this protocol if you want to use a custom error view.
 */
public protocol CIOErrorView: NSObjectProtocol {
    /**
     Returns a UIView instance. If your UIView implements this protocol, simply return self.

     - returns: UIView to be added to the view hierarchy if an error occurs.
    */
    func asView() -> UIView

    /**
     Method called when if an error occurs.

     - parameter errorString: String value of an error that occurred.
     */
    func setErrorString(errorString: String)
}
