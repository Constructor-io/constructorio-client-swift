//
//  AutocompleteViewControllerTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/4/19.
//  Copyright © 2019 xd. All rights reserved.
//

import XCTest
import ConstructorAutocomplete

class AutocompleteViewControllerTests: XCTestCase, CIOAutocompleteDelegate {

    var viewController: CIOAutocompleteViewController!

    var viewDidLoadExpectation: XCTestExpectation?
    var expectationSelectResult: XCTestExpectation?
    var expectation: XCTestExpectation!

    override func setUp() {
        self.expectation = nil
        self.viewDidLoadExpectation = nil
    }

    func initializeViewController(){
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey)
        self.viewController = CIOAutocompleteViewController(config: config)
        self.viewController.delegate = self
        self.viewController.viewDidLoad()
    }

    func testAutocomplete_ViewDidLoad() {
        self.viewDidLoadExpectation = XCTestExpectation(description: "View did load should get called")
        self.initializeViewController()
        self.waitForUIExpectation()
    }

    func testAutocomplete_ViewWillAppear() {
        self.expectation = XCTestExpectation(description: "View will appear should get called")
        self.initializeViewController()
        self.viewController.viewWillAppear(true)
        self.waitForUIExpectation()
    }

    func testAutocomplete_TimerFired(){
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

    func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOResult) {
        self.expectationSelectResult?.fulfill()
    }

}
