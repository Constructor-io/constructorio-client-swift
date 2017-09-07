//
//  SearchErrorView.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class SearchErrorView: UIView, CIOErrorView {

    @IBOutlet weak var labelText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = CIOStyle.colorLightGrey()
    }

    func asView() -> UIView {
        return self
    }

    func setErrorString(errorString: String) {
        self.labelText.text = errorString
    }
}
