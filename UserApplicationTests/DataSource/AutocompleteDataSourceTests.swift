//
//  AutocompleteDataSourceTests.swift
//  UserApplicationTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete
class AutocompleteDataSourceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_styleSearchBarCalled_onLoad() {
        let expectation = self.expectation(description: self.dataSourceExpectationDescription(methodName: "styleSearchBar"))
        let viewController = CIOAutocompleteViewController.instantiate()

        class TestDataSource: ExpectationHandler, CIOAutocompleteDataSource {

            func styleSearchBar(searchBar: UISearchBar, in autocompleteController: CIOAutocompleteViewController) {
                self.expectation.fulfill()
            }
        }

        let testDataSource = TestDataSource(expectation: expectation)

        viewController.dataSource = testDataSource
        viewController.showInNewWindow()

        self.waitForExpectationWithDefaultHandler()
    }

    func test_setupFontCalled_onLoad() {
        let expectation = self.expectation(description: self.dataSourceExpectationDescription(methodName: "fontNormal"))
        let viewController = CIOAutocompleteViewController.instantiate()

        class TestDataSource: ExpectationHandler, CIOAutocompleteDataSource {

            func fontNormal(in autocompleteController: CIOAutocompleteViewController) -> UIFont {
                self.expectation.fulfill()
                return UIFont.systemFont(ofSize: 16)
            }
        }

        let testDataSource = TestDataSource(expectation: expectation)

        viewController.dataSource = testDataSource
        viewController.showInNewWindow()

        self.waitForExpectationWithDefaultHandler()
    }

    func test_setupFontBoldCalled_onLoad() {
        let expectation = self.expectation(description: self.dataSourceExpectationDescription(methodName: "fontBold"))
        let viewController = CIOAutocompleteViewController.instantiate()

        class TestDataSource: ExpectationHandler, CIOAutocompleteDataSource {

            func fontBold(in autocompleteController: CIOAutocompleteViewController) -> UIFont {
                self.expectation.fulfill()
                return UIFont.systemFont(ofSize: 16)
            }
        }

        let testDataSource = TestDataSource(expectation: expectation)

        viewController.dataSource = testDataSource
        viewController.showInNewWindow()

        self.waitForExpectationWithDefaultHandler()
    }

    func test_setupBackgroundViewCalled_onLoad() {
        let expectation = self.expectation(description: self.dataSourceExpectationDescription(methodName: "fontBold"))
        let viewController = CIOAutocompleteViewController.instantiate()

        class TestDataSource: ExpectationHandler, CIOAutocompleteDataSource {

            func backgroundView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
                self.expectation.fulfill()
                return nil
            }
        }

        let testDataSource = TestDataSource(expectation: expectation)

        viewController.dataSource = testDataSource
        viewController.showInNewWindow()

        self.waitForExpectationWithDefaultHandler()
    }

    func test_setupCellNibCalled_onLoad() {
        let expectation = self.expectation(description: self.dataSourceExpectationDescription(methodName: "customCellNib"))
        let viewController = CIOAutocompleteViewController.instantiate()

        class TestDataSource: ExpectationHandler, CIOAutocompleteDataSource {

            func customCellNib(in autocompleteController: CIOAutocompleteViewController) -> UINib {
                self.expectation.fulfill()
                return UINib(nibName: " ", bundle: nil)
            }
        }

        let testDataSource = TestDataSource(expectation: expectation)

        viewController.dataSource = testDataSource
        viewController.showInNewWindow()

        self.waitForExpectationWithDefaultHandler()
    }

    func test_setupCellClassCalled_onLoad() {
        let expectation = self.expectation(description: self.dataSourceExpectationDescription(methodName: "customCellClass"))
        let viewController = CIOAutocompleteViewController.instantiate()

        class TestDataSource: ExpectationHandler, CIOAutocompleteDataSource {

            func customCellClass(in autocompleteController: CIOAutocompleteViewController) -> AnyClass {
                self.expectation.fulfill()
                return UITableViewCell.self
            }
        }

        let testDataSource = TestDataSource(expectation: expectation)

        viewController.dataSource = testDataSource
        viewController.showInNewWindow()

        self.waitForExpectationWithDefaultHandler()
    }

    fileprivate func dataSourceExpectationDescription(methodName: String) -> String {
        return "\(methodName) dataSource method should get called."
    }
}
