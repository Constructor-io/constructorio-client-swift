//
//  AutocompleteDelegateTests.swift
//  UserApplicationTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorIO

class AutocompleteDelegateTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_viewDidLoad_callsDelegateMethod() {
        let expectation = self.expectation(description: "searchControllerDidLoad delegate method should get called.")
        let viewController = CIOAutocompleteViewController.instantiate()

        let delegate = AutocompleteDelegateWrapper()
        viewController.delegate = delegate

        delegate.onLoad = {
            expectation.fulfill()
        }

        viewController.showInNewWindow()

        self.waitForExpectationWithDefaultHandler()
    }

    func test_viewWillAppear_callsDelegateMethod() {
        let expectation = self.expectation(description: "searchControllerWillAppear delegate method should get called.")
        let viewController = CIOAutocompleteViewController.instantiate()

        let delegate = AutocompleteDelegateWrapper()
        viewController.delegate = delegate

        delegate.onWillAppear = {
            expectation.fulfill()
        }

        viewController.showInNewWindow()

        self.waitForExpectationWithDefaultHandler()
    }

    func test_searching_callsDelegateMethod() {
        let expectation = self.expectation(description: "searchControllerWillAppear delegate method should get called.")
        let viewController = CIOAutocompleteViewController.instantiate()

        let searchBar = UISearchBar()
        let searchTerm = "term"

        let delegate = AutocompleteDelegateWrapper()
        viewController.delegate = delegate

        delegate.onSearchPerformed = { term in
            XCTAssertEqual(searchTerm, term, "Delegate method should return exactly the same search term that the user typed")
            expectation.fulfill()
        }

        viewController.showInNewWindow()

        viewController.searchBar(searchBar, textDidChange: searchTerm)
        self.waitForExpectationWithDefaultHandler()
    }

}
