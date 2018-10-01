//
//  AutocompleteTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 8/22/18.
//  Copyright © 2018 xd. All rights reserved.
//

import XCTest
@testable import ConstructorAutocomplete

class AutocompleteQueryTests: XCTestCase {
    
    var constructor: ConstructorIO!
    
    override func setUp() {
        super.setUp()
        self.constructor =  ConstructorIO(config: TestConstants.testConfig)
    }
    
    func testAutocompleteQuery_CreatesValidRequest(){
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)
        
        let builder = CIOBuilder(expectation: "Calling Autocomplete should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&s=1&i=\(kRegexClientID)&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C"), builder.create())

        self.constructor.autocomplete(forQuery: query) { (response) in }
        self.wait(for: builder.expectation)
    }
    
}
