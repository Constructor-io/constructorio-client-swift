//
//  DetailsViewController.swift
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
    weak var buttonTrackResultsLoaded: UIButton!
    
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
        
        var button = self.createButton(title: "Track conversion")
        button.addTarget(self, action: #selector(didTapOnButtonTrackConversion(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        self.buttonTrackConversion = button
        
        button = self.createButton(title: "Track search results loaded")
        button.addTarget(self, action: #selector(didTapOnButtonTrackResultsLoaded(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        self.buttonTrackResultsLoaded = button
        
    }
    
    func createButton(title: String) -> UIButton{
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 6.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        return button
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var center = self.buttonTrackConversion.center
        center.x = self.view.frame.size.width/2
        center.y = 3*self.buttonHeight
        self.buttonTrackConversion.center = center
        
        let bottom = self.buttonTrackResultsLoaded.frame.minY + self.buttonTrackResultsLoaded.frame.height
        let distance: CGFloat = 16
        
        center.y = bottom + distance + self.buttonHeight/2
        self.buttonTrackResultsLoaded.center = center
    }
    
    func didTapOnButtonTrackConversion(_ sender: UIButton){
        let revenue: Int = Int(arc4random() % 1000)
        self.constructorIO.trackConversion(itemID: self.result.autocompleteResult.id, revenue: revenue, searchTerm: "a term", sectionName: nil)
    }
    
    func didTapOnButtonTrackResultsLoaded(_ sender: UIButton){
        let resultCount = 10
        self.constructorIO.trackSearchResultsLoaded(searchTerm: "a search term", resultCount: resultCount)
    }
}
