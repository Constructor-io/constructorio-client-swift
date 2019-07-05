//
//  UIViewAnimationTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class UIViewAnimationTests: XCTestCase {

    func testViewFadeIn() {
        let expectation = XCTestExpectation(description: "View alpha should be 1 after completion handler is called.")

        let view = UIView(frame: .zero)
        view.alpha = 0

        view.fadeIn(duration: 0.5, completion: { _ in
            XCTAssertEqual(view.alpha, 1.0)
            expectation.fulfill()
        })

        self.wait(for: [expectation], timeout: 1.0)
    }

    func testViewFadeOut() {
        let expectation = XCTestExpectation(description: "View alpha should be 0 after completion handler is called.")

        let view = UIView(frame: .zero)
        view.alpha = 1

        view.fadeOutAndRemove(duration: 0.5, completion: { _ in
            XCTAssertEqual(view.alpha, 0.0)
            expectation.fulfill()
        })

        self.wait(for: [expectation], timeout: 1.0)
    }

}
