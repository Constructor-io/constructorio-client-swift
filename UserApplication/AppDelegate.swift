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
class AppDelegate: UIResponder, UIApplicationDelegate, CIOAutocompleteDelegate, CIOAutocompleteUICustomization, ConstructorIOProvider {

    var window: UIWindow?

    var constructorIO: ConstructorIO!

    func provideConstructorInstance() -> ConstructorIO {
        return self.constructorIO
    }

    lazy var cart: Cart = Cart()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

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
        let key = "key_K2hlXt5aVSwoI1Uw"
        let config = ConstructorIOConfig(apiKey: key,
                                        resultCount: AutocompleteResultCount(numResultsForSection: ["Search Suggestions" : 3, "Products" : 0]))
        let viewController = CIOAutocompleteViewController(config: config)
        viewController.searchBarDisplayMode = CIOSearchBarDisplayMode.navigationBar
        viewController.searchBarShouldShowCancelButton = false
        
        // set the delegate in order to react to various events
        viewController.delegate = self
        
        // set the customization to adjust the look and feel of the UI
        viewController.uiCustomization = self
        
        let bgColor = UIColor.white
        
        // embed it in the navigation controller
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.barTintColor = bgColor
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        // Listen for cart changes and react to item being add event
        NotificationCenter.default.addObserver(forName: kNotificationDidAddItemToCart, object: nil, queue: OperationQueue.main) { notification in
            guard let item = notification.cartItem() else { return }
            guard let constructor = viewController.constructorIO else { return }
            constructor.trackConversion(itemName: item.title, customerID: "a-customer-id", revenue: Double(item.price))
        }
    }

    // MARK: UI Customization

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
    
    func shouldShowSectionHeader(sectionName: String, in autocompleteController: CIOAutocompleteViewController) -> Bool {
        return false
    }
    
    func sectionSort(in autocompleteController: CIOAutocompleteViewController) -> ((String, String) -> Bool) {
        return { (s1, s2) in return s1 > s2 }
    }

    func errorView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
        return UINib(nibName: "CustomErrorView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }

    func customizeSearchController(searchController: UISearchController, in autocompleteController: CIOAutocompleteViewController) {
        // customize search bar
        searchController.searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchController.searchBar.returnKeyType = .search
        
        if let textField = searchController.searchBar.searchTextField(){
            let val: CGFloat = 0.94
            textField.backgroundColor = UIColor(red: val, green: val, blue: val, alpha: 1.0)
        }
        
        // customize search controller behaviour
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    // MARK: Delegate

    func autocompleteController(controller: CIOAutocompleteViewController, errorDidOccur error: Error) {

        if let err = error as? CIOError {
            switch(err) {
            case .missingApiKey:
                print("Missing api key error")
            default:
                print("Error occured: \(error.localizedDescription)")
            }
        }
    }
    
    func autocompleteController(controller: CIOAutocompleteViewController, didLoadResults results: [CIOResult], for searchTerm: String) {}
    
    func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOResult) {
        print("item selected \(result)")

        self.constructorIO = controller.constructorIO

        if let navigationController = self.window?.rootViewController as? UINavigationController{
            let viewModel = SearchViewModel(term: result.autocompleteResult.value, group: result.group, constructorProvider: self, cart: self.cart)
            let searchVC = SearchViewController(viewModel: viewModel, constructorProvider: self)
            navigationController.pushViewController(searchVC, animated: true)
        }
    }

    func autocompleteController(controller: CIOAutocompleteViewController, didPerformSearch searchTerm: String) {
        print("Search performed for term \(searchTerm)")
    }

    func autocompleteControllerWillAppear(controller: CIOAutocompleteViewController) {
        print("Search controller will appear")
        if controller.constructorIO.userID == nil{
            controller.constructorIO.userID = "user_id$1 3"
        }
    }

    func autocompleteControllerDidLoad(controller: CIOAutocompleteViewController) {
        print("Search controller did load")
    }

    func searchBarPlaceholder(in autocompleteController: CIOAutocompleteViewController) -> String {
        return "Search"
    }
}
