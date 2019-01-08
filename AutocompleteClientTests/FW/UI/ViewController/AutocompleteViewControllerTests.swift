//
//  AutocompleteViewControllerTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/4/19.
//  Copyright © 2019 xd. All rights reserved.
//

import XCTest
import ConstructorAutocomplete

class AutocompleteViewControllerTests: XCTestCase, CIOAutocompleteDelegate, CIOAutocompleteUICustomization {

    var viewController: CIOAutocompleteViewController!

    var viewDidLoadExpectation: XCTestExpectation?
    var expectationSelectResult: XCTestExpectation?
    var expectation: XCTestExpectation!

    override func setUp() {
        self.expectation = nil
        self.viewDidLoadExpectation = nil
    }

    func initializeViewController(shouldCallViewDidLoad: Bool = true){
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey)
        self.viewController = CIOAutocompleteViewController(config: config)
        self.viewController.delegate = self

        if shouldCallViewDidLoad{
            self.viewController.viewDidLoad()
        }
    }

    func testAutocompleteViewController_ViewDidLoad() {
        self.viewDidLoadExpectation = XCTestExpectation(description: "View did load should get called")
        self.initializeViewController()
        self.waitForUIExpectation()
    }

    func testAutocompleteViewController_ViewWillAppear() {
        self.expectation = XCTestExpectation(description: "View will appear should get called")
        self.initializeViewController()
        self.viewController.viewWillAppear(true)
        self.waitForUIExpectation()
    }

    func testAutocompleteViewController_DisplayError(){
        self.initializeViewController()

        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unknown error"])

        // call with no uiCustomization set
        self.viewController.displayError(error: error)

        self.viewController.uiCustomization = self
        // call with no previous error view set
        self.viewController.displayError(error: error)

        // call with error view previously set
        self.viewController.displayError(error: error)

        self.viewController.uiCustomization = nil
    }

    func testAutocompleteViewController_SearchBarDisplayMode_NavigationBar(){
        self.initializeViewController(shouldCallViewDidLoad: false)
        self.viewController.searchBarDisplayMode = .navigationBar
        self.viewController.viewDidLoad()

        XCTAssertEqual(self.viewController.searchBarDisplayMode, .navigationBar)
    }

    func testAutocompleteViewController_SearchBarDisplayMode_TableViewHeader(){
        self.initializeViewController(shouldCallViewDidLoad: false)
        self.viewController.searchBarDisplayMode = .tableViewHeader
        self.viewController.viewDidLoad()

        XCTAssertEqual(self.viewController.searchBarDisplayMode, .tableViewHeader)
    }

    func testAutocompleteViewController_CustomBackgroundEmptyScreen(){
        self.initializeViewController(shouldCallViewDidLoad: false)
        self.viewController.uiCustomization = self
        self.viewController.viewDidLoad()
        XCTAssertNotNil(self.backgroundView.superview)
    }

    func testAutocompleteViewController_CustomFontNormal(){
        self.initializeViewController(shouldCallViewDidLoad: false)
        self.viewController.uiCustomization = self
        self.viewController.viewDidLoad()

        let attributesProvider = self.viewController.highlighter.attributesProvider as? BoldAttributesProvider
        XCTAssertNotNil(attributesProvider)

        XCTAssertEqual(attributesProvider!.fontNormal, self.fontNormal)
    }

    var fontNormal: UIFont = UIFont.systemFont(ofSize: 1)
    func fontNormal(in autocompleteController: CIOAutocompleteViewController) -> UIFont {
        return self.fontNormal
    }

    func testAutocompleteViewController_CustomFontBold(){
        self.initializeViewController()
        self.viewController.uiCustomization = self
        self.viewController.viewDidLoad()

        let attributesProvider = self.viewController.highlighter.attributesProvider as? BoldAttributesProvider
        XCTAssertNotNil(attributesProvider)

        XCTAssertEqual(attributesProvider!.fontBold, self.fontBold) 
    }

    var fontBold: UIFont = UIFont.systemFont(ofSize: 1)
    func fontBold(in autocompleteController: CIOAutocompleteViewController) -> UIFont {
        return self.fontBold
    }

    func testAutocompleteViewController_CustomCellClass(){
        class UICustomization: CIOAutocompleteUICustomization{
            func customCellClass(in autocompleteController: CIOAutocompleteViewController) -> AnyClass {
                class CustomCellClass: UITableViewCell{}
                return CustomCellClass.self
            }
        }
        self.initializeViewController(shouldCallViewDidLoad: false)
        let customization = UICustomization()
        self.viewController.uiCustomization = customization
        self.viewController.viewDidLoad()
    }

    func testAutocompleteViewController_CustomCellNib(){
        class UICustomization: CIOAutocompleteUICustomization{
            func customCellNib(in autocompleteController: CIOAutocompleteViewController) -> UINib {
                return UINib(nibName: "DefaulSearchItemCell", bundle: Bundle.testBundle())
            }
        }
        self.initializeViewController(shouldCallViewDidLoad: false)
        let customization = UICustomization()
        self.viewController.uiCustomization = customization
        self.viewController.viewDidLoad()
    }

    func testAutocompleteViewController_CustomSortFunction(){
        class UICustomization: CIOAutocompleteUICustomization{
            func sectionSort(in autocompleteController: CIOAutocompleteViewController) -> ((String, String) -> Bool) {
                return { (s1: String, s2: String) -> Bool in
                    return s1 > s2
                }
            }
        }
        self.initializeViewController(shouldCallViewDidLoad: false)
        let customization = UICustomization()
        self.viewController.uiCustomization = customization
        self.viewController.viewDidLoad()
    }

//
//    func testAutocompleteViewController(){}
//
//    func testAutocompleteViewController(){}
//
//    func testAutocompleteViewController(){}
//


    func testAutocompleteViewController_TimerFired(){
        self.expectation = XCTestExpectation(description: "Timer should fire")
        self.initializeViewController()

        self.viewController.setTimerFired(with: "term")
        self.waitForUIExpectation()
    }

//    func testAutocomplete_ResultSelected(){
//        self.expectationSelectResult = XCTestExpectation(description: "Result select event should occur.")
//        self.initializeViewController()
//
//        self.viewController.tableView(self.viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
//    }

    func waitForUIExpectation(){
        var expectations: [XCTestExpectation] = []

        if let exp = self.viewDidLoadExpectation{
            expectations.append(exp)
        }

        if let exp = self.expectation{
            expectations.append(exp)
        }

        self.wait(for: expectations, timeout: TestConstants.defaultUserInterfaceExpectationTimeout)
    }

    func autocompleteControllerDidLoad(controller: CIOAutocompleteViewController){
        self.viewDidLoadExpectation?.fulfill()
    }

    func autocompleteControllerWillAppear(controller: CIOAutocompleteViewController) {
        self.expectation.fulfill()
    }

    func autocompleteController(controller: CIOAutocompleteViewController, didPerformSearch searchTerm: String) {
        self.expectation.fulfill()
    }

    var backgroundView: UIView = UIView(frame: .zero)
    func backgroundView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
        return self.backgroundView
    }

    func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOResult) {
        self.expectationSelectResult?.fulfill()
    }

    func errorView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
        class CustomErrorView: UIView, CIOErrorView{
            func asView() -> UIView { return self }
            func setErrorString(errorString: String) {}
        }
        return CustomErrorView(frame: .zero)
    }

}
