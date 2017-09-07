//
//  CustomErrorView.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorIO

class CustomErrorView: UIView, CIOErrorView {

    @IBOutlet weak var labelError: UILabel!

    func asView() -> UIView {
        return self
    }

    func setErrorString(errorString: String) {
        self.labelError.text = errorString
    }

}
