//
//  FilterHeaderView.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

class FilterHeaderView: UIView {

    weak var tapDelegate: FilterHeaderDelegate?
    @IBOutlet weak var imageViewSort: UIImageView!
    @IBOutlet weak var labelSort: UILabel!
    @IBOutlet weak var labelFilter: UILabel!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewSort: UIView!

    class func instantiateFromNib() -> FilterHeaderView{
        let v =  UINib(nibName: "FilterHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! FilterHeaderView
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.viewFilter.isUserInteractionEnabled = true
        self.viewSort.isUserInteractionEnabled = true

        self.viewFilter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnViewFilter)))
        self.viewSort.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnViewSort)))

        self.layer.borderWidth = 0.6
        self.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
    }

    @objc
    func didTapOnViewSort(){
        self.tapDelegate?.didTapOnSortView()
    }

    @objc
    func didTapOnViewFilter(){
        self.tapDelegate?.didTapOnFilterView()
    }
}
