//
//  CIOAutocompleteViewController.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

class DetailsViewController: UIViewController {

    var result: CIOResult!
    var constructorIO: ConstructorIO!
    
    var buttonWidth: CGFloat = 160
    var buttonHeight: CGFloat = 85
    weak var buttonTrackConversion: UIButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = self.result.autocompleteResult.value
        
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        button.setTitle("Track conversion", for: .normal)
        button.addTarget(self, action: #selector(didTapOnButtonTrackConversion(_:)), for: .touchUpInside)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 6.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        
        self.view.addSubview(button)
        self.buttonTrackConversion = button
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var center = self.buttonTrackConversion.center
        center.x = self.view.frame.size.width/2
        center.y = 3*self.buttonHeight
        self.buttonTrackConversion.center = center
    }
    
    func didTapOnButtonTrackConversion(_ sender: UIButton){
        let revenue: Int = Int(arc4random() % 1000)
        self.constructorIO.tracking.trackConversion(itemID: self.result.autocompleteResult.id, revenue: revenue, searchTerm: "a term")
    }

}
