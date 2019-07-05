//
//  EmptyScreenView.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public class EmptyScreenView: UIView {

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = CIOStyle.colorLightGrey()
    }

}
