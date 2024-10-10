//
//  BadgeView.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

class BadgeView: UIView {

    private var label: UILabel

    init(){
        self.label = UILabel(frame: .zero)
        super.init(frame: .zero)
        self.backgroundColor = UIColor.red
        self.clipsToBounds = true

        self.label.backgroundColor = .clear
        self.label.textAlignment = .center
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textColor = UIColor.white
        self.label.adjustsFontSizeToFitWidth = true
        self.label.baselineAdjustment = .alignCenters

        self.label.font = UIFont.systemFont(ofSize: 10)

        self.addSubview(label)
        self.label.pinToSuperviewTop(2)
        self.label.pinToSuperviewBottom(2)
        self.label.pinToSuperviewLeft(2)
        self.label.pinToSuperviewRight(2)
    }

    func setValue(text: String){
        self.label.text = text
        self.label.layoutIfNeeded()
        self.label.setNeedsDisplay()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height/2
    }

}
