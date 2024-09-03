//
//  CustomErrorView.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

class CustomErrorView: UIView, CIOErrorView {

    @IBOutlet weak var labelError: UILabel!

    func asView() -> UIView {
        return self
    }

    func setErrorString(errorString: String) {
        self.labelError.text = errorString
    }

}
