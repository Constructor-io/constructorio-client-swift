//
//  ViewController.swift
//  SearchFWTestApp
//
//  Created by Nikola Markovic on 8/30/17.
//  Copyright © 2017 xd. All rights reserved.
//

import UIKit
import SearchFW

class ViewController: UIViewController, CIOAutocompleteDelegate, CIOAutocompleteUICustomization {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func rowHeight() -> CGFloat {
        return 35
    }
//
    func styleResultLabel(label: UILabel) {
        label.textColor = self.randomColor()
    }
//
//    func styleResultCell(cell: UITableViewCell) {
//        cell.contentView.backgroundColor = self.randomColor()
//    }

    var i = 1
    func randomColor() -> UIColor {
        let colors = [UIColor.red, .blue, .purple, .orange, .black]
        let color = colors[i%colors.count]
        i += 1
        return color
    }

    @IBAction func didTapOnSearch(_ sender: Any) {
        let vc = CIOAutocompleteViewController()
        vc.autocompleteKey = "key_OucJxxrfiTVUQx0C"
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        vc.delegate = self
        vc.uiCustomization = self
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

    @objc
    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Background view

    // custom background view
//    func backgroundView() -> UIView? {
//        var view = UIView()
//        view.backgroundColor = UIColor.blue
//        return view
//    }

    // no background view
//    func backgroundView() -> UIView? {
//        return nil
//    }

    // MARK: SearchBar

    func styleSearchBar(searchBar: UISearchBar) {
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchBar.barStyle = .black
        searchBar.returnKeyType = .yahoo
    }

    // MARK: Delegate

    func userDidSelect(result: CIOResult) {
        print("item selected \(result)")
    }

    func userDidPerformSearch(searchTerm: String) {
        print("Search performed for term \(searchTerm)")
    }

    func searchControllerWillAppear() {
        print("Search controller will appear")
    }

    func searchControllerDidLoad() {
        print("Search controller did load")
    }

    func searchBarPlaceholder() -> String {
        return "Custom search placeholder"
    }
}
