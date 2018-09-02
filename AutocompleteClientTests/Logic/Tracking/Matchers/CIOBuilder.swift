//
//  CIOBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest

class CIOBuilder {

    let expectation: XCTestExpectation
    let builder: Builder
    
    init(expectation: String, builder: @escaping Builder) {
        self.expectation = XCTestExpectation(description: expectation)
        self.builder = builder
    }
    
    func create() -> Builder{
        return { request in
            // at this point we know that request has been made and we can fullfil the expectation and delegate the request object
            // to the builder provided
            self.expectation.fulfill()
            return self.builder(request)
        }
    }
}
