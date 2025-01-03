//
//  CustomSearchBar.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

public class CustomSearchBar: UISearchBar {

    public var shouldShowCancelButton = false

    public init() {
        super.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(self.shouldShowCancelButton && self.isFirstResponder, animated: animated)
    }

}
