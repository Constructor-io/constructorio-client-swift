//
//  XCTest+TimeoutFail.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest

extension XCTestCase {

    func defaultTimeoutFailureHandler() -> ((_ error: Error?) -> Void) {
        return { error in
            if error != nil {
                XCTFail("Test timed out.")
            }
        }
    }

    func waitForExpectationWithDefaultHandler(_ timeout: TimeInterval = TestConstants.defaultExpectationTimeout) {
        self.waitForExpectations(timeout: timeout, handler: self.defaultTimeoutFailureHandler())
    }

    func wait(for expectation: XCTestExpectation) {
        self.wait(for: [expectation], timeout: TestConstants.defaultExpectationTimeout)
    }
}
