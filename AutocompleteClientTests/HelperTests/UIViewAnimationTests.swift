//
//  UIViewAnimationTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/4/19.
//  Copyright © 2019 xd. All rights reserved.
//

import XCTest
import ConstructorAutocomplete

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
