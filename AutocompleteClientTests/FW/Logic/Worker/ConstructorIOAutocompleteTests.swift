//
//  ConstructorIOAutocompleteTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class ConstructorIOAutocompleteTests: XCTestCase {
    
    var constructor: ConstructorIO!
    
    override func setUp() {
        super.setUp()
        self.constructor =  ConstructorIO(config: TestConstants.testConfig)
    }
    
    func testAutocompleteQuery_CreatesValidRequest(){
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)
        
        let builder = CIOBuilder(expectation: "Calling Autocomplete should send a valid request.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?s=1&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&_dt=\(kRegexTimestamp)"), builder.create())

        self.constructor.autocomplete(forQuery: query) { (response) in }
        self.wait(for: builder.expectation)
    }
    
}
