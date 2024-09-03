//
//  EmptyScreenView.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

public class EmptyScreenView: UIView {

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = CIOStyle.colorLightGrey()
    }

}
