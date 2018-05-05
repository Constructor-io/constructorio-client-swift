//
//  AppDelegate.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CIOAutocompleteDelegate, CIOAutocompleteDataSource {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.showAutocompleteViewControllerAsRoot()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func showAutocompleteViewControllerAsRoot() {
        // Instantiate the autocomplete controller
        let key = "key_AttLywTIsQjS0nao"

        let viewController = CIOAutocompleteViewController(autocompleteKey: key)
        
        viewController.searchBarDisplayMode = CIOSearchBarDisplayMode.NavigationBar
        viewController.searchBarShouldShowCancelButton = true
        
        // set the delegate in order to react to various events
        viewController.delegate = self
        
        // set the data source to customize the look and feel of the UI
        viewController.dataSource = self
        
        let bgColor = UIColor(red: 67/255.0, green: 152/255.0, blue: 234/255.0, alpha: 1.0)
        
        // embed it in the navigation controller
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.barTintColor = bgColor
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        viewController.highlighter.attributesProvider = CustomAttributesProvider()
    }

    // MARK: DataSource

    /*
    func shouldShowSectionHeader(sectionName: String, in autocompleteController: CIOAutocompleteViewController) -> Bool {
        return sectionName.lowercased() != "products"
    }
    */

    func sectionHeaderView(sectionName: String, in autocompleteController: CIOAutocompleteViewController) -> UIView? {
        let headerView = UIView(frame: CGRect.zero)
        headerView.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        let constraintCenterHorizontally = NSLayoutConstraint(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: label, attribute: .centerX, multiplier: 1.0, constant: 0)
        headerView.addConstraint(constraintCenterHorizontally)
        
        let constraintCenterVertically = NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1.0, constant: 0)
        headerView.addConstraint(constraintCenterVertically)
        
        label.text = sectionName
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        return headerView
    }
    
    func sectionHeaderViewHeight(sectionName: String, in autocompleteController: CIOAutocompleteViewController) -> CGFloat {
        return 30
    }
    
    func sectionSort(in autocompleteController: CIOAutocompleteViewController) -> ((String, String) -> Bool) {
        return { (s1, s2) in return s1 > s2 }
    }
    
    func rowHeight(in autocompleteController: CIOAutocompleteViewController) -> CGFloat {
        return 35
    }

    func styleResultLabel(label: UILabel, indexPath: IndexPath, in autocompleteController: CIOAutocompleteViewController) {
        label.textColor = self.randomColor()
    }
    
    func styleResultCell(cell: UITableViewCell, indexPath: IndexPath, in autocompleteController: CIOAutocompleteViewController) {
        let val: CGFloat = 0.97
        cell.backgroundColor = UIColor(red: val, green: val, blue: val, alpha: 1.0)
    }

    var i = 1
    func randomColor() -> UIColor {
        let colors = [UIColor.red, .blue, .purple, .orange, .black]
        let color = colors[i%colors.count]
        i += 1
        return color
    }

    func backgroundView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
        let view = UINib(nibName: "CustomBackgroundView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CustomBackgroundView
        return view
    }

    func errorView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
        return UINib(nibName: "CustomErrorView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }

    func customCellNib(in autocompleteController: CIOAutocompleteViewController) -> UINib {
        return UINib(nibName: "CustomTableViewCellOne", bundle: nil)
    }
    
/*
    func customCellClass(in autocompleteController: CIOAutocompleteViewController) -> AnyClass {
        return CustomTableViewCellTwo.self
    }
*/
    // No background view
//    func backgroundView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
//        return nil
//    }

    // MARK: Parsing
    
//    func autocompleteController(controller: CIOAutocompleteViewController, shouldParseResult result: CIOAutocompleteResult, inGroup group: CIOGroup?) -> Bool {
//        return true
//    }
    
    func autocompleteController(controller: CIOAutocompleteViewController, shouldParseResultsInSection sectionName: String) -> Bool {
        return sectionName.lowercased() != "products"
    }
    
    // MARK: SearchBar

    func customizeSearchController(searchController: UISearchController, in autocompleteController: CIOAutocompleteViewController) {
        // customize search bar
        searchController.searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchController.searchBar.returnKeyType = .search
//        searchController.searchBar.showsCancelButton = true
        // customize search controller behaviour
        searchController.dimsBackgroundDuringPresentation = false
    }
    // MARK: Delegate

    func shouldShowSectionHeader(sectionName: String, in autocompleteController: CIOAutocompleteViewController) -> Bool {
        return false
    }
    
    func autocompleteController(controller: CIOAutocompleteViewController, errorDidOccur error: Error) {

        if let err = error as? CIOError {
            switch(err) {
            case .missingAutocompleteKey:
                print("Missing autocomplete key error")
            default:
                print("Error occured: \(error.localizedDescription)")
            }
        }
    }


    func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOResult) {
        print("item selected \(result)")
        
        if let navigationController = self.window?.rootViewController as? UINavigationController{
            let detailsVC = DetailsViewController()
            detailsVC.itemName = result.autocompleteResult.value
            navigationController.pushViewController(detailsVC, animated: true)
        }
    }

    func autocompleteController(controller: CIOAutocompleteViewController, didPerformSearch searchTerm: String) {
        print("Search performed for term \(searchTerm)")
    }

    func autocompleteControllerWillAppear(controller: CIOAutocompleteViewController) {
        print("Search controller will appear")
    }

    func autocompleteControllerDidLoad(controller: CIOAutocompleteViewController) {
        print("Search controller did load")
    }

    func searchBarPlaceholder(in autocompleteController: CIOAutocompleteViewController) -> String {
        return "Custom search placeholder"
    }
}
