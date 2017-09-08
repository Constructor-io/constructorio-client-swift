//
//  ViewModelTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorIO

class ViewModelTests: XCTestCase {

    var viewModel: AutocompleteViewModel!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        self.viewModel = AutocompleteViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_SettingLastInitiatedQueryResult_ShouldChangeViewModelData() {

        let failMessage = "Result order should follow the order in which the setters were called."

        let expectation = self.expectation(description: "Setting last initiated query result should change the ViewModel data.")
        let query = CIOAutocompleteQuery(query: "")

        let firstResult = AutocompleteResult(query: query, timestamp: 10)

        // mock out responses;
        // TODO: Move eventually to extensions
        let sections1 = ["firstResponseSection": [self.mockCIOResult("value1")]]
        let firstResponse = CIOResponse(sections: sections1, metadata: [:], json: [:])
        firstResult.response = firstResponse

        let secondResult = AutocompleteResult(query: query, timestamp: 20)
        let sections2 = ["secondResponseSection": [self.mockCIOResult("value2")]]
        let secondResponse = CIOResponse(sections: sections2, metadata: [:], json: [:])
        secondResult.response = secondResponse

        // set the delegate in order to list to viewModel events
        let delegate = ClosureAutocompleteViewModelDelegate(viewModel: self.viewModel)

        var idx = 0
        var results = [firstResult, secondResult]

        // onSet should be called two times, one for each result we pass
        delegate.onSetResult = { result in
            XCTAssertTrue(result === results[idx], failMessage)
            idx += 1
            if idx >= results.count {
                expectation.fulfill()
            }
        }

        delegate.onIgnoreResult = { result in
            XCTFail("When results are passed in the correct order, no result should be ignored.")
        }

        // we call the setter with the first result (that was initiated earlier)
        viewModel.set(searchResult: firstResult, completionHandler: {})

        // we call the setter with the second result (that was initiated after the first one)
        viewModel.set(searchResult: secondResult, completionHandler: {})

        self.waitForExpectationWithDefaultHandler()
    }

    // TODO: move to an extension
    func mockCIOResult(_ value: String) -> CIOResult {
        return CIOResult(json: ["value": value])!
    }

    func test_SettingEarlierInitiatedQueryResult_ShouldNotChangeViewModelData() {
        let expectation = self.expectation(description: "Setting last initiated query result should change the ViewModel data.")
        let query = CIOAutocompleteQuery(query: "")

        // mock out responses;
        // TODO: Move eventually to extensions
        let firstResult = AutocompleteResult(query: query, timestamp: 20)
        let sections1 = ["firstResponseSection": [self.mockCIOResult("value1")]]
        let firstResponse = CIOResponse(sections: sections1, metadata: [:], json: [:])
        firstResult.response = firstResponse

        let secondResult = AutocompleteResult(query: query, timestamp: 10)
        let sections2 = ["secondResponseSection": [self.mockCIOResult("value2")]]
        let secondResponse = CIOResponse(sections: sections2, metadata: [:], json: [:])
        secondResult.response = secondResponse

        // set the delegate in order to list to viewModel events
        let delegate = ClosureAutocompleteViewModelDelegate(viewModel: self.viewModel)

        delegate.onSetResult = { result in
            // didSet should only be called for the first result
            XCTAssertTrue(result === firstResult, "Results that were passed first should be set.")
        }

        delegate.onIgnoreResult = { result in
            // second result should be ignored
            XCTAssertTrue(result === secondResult, "Results that were initiated after the previous one should be ignored.")

            expectation.fulfill()
        }

        // we call the setter with the first result (that was initiated earlier)
        viewModel.set(searchResult: firstResult, completionHandler: {})

        // we call the setter with the second result (that was initiated after the first one)
        viewModel.set(searchResult: secondResult, completionHandler: {})

        self.waitForExpectationWithDefaultHandler()
    }

}
