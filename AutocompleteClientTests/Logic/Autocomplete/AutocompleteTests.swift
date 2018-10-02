//
//  AutocompleteTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class AutocompleteTests: XCTestCase {
    
    var constructor: ConstructorIO!
    
    override func setUp() {
        super.setUp()
<<<<<<< HEAD
        self.constructor =  ConstructorIO(config: TestConstants.testConfig)
=======
        self.constructor = ConstructorIO(config: AutocompleteConfig(autocompleteKey: TestConstants.testAutocompleteKey))
>>>>>>> 9629388ab390297b07e997cc8e4a18eb93aba86b
    }
    
    func testCallingAutocomplete_CreatesValidRequest(){
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)
        
        let builder = CIOBuilder(expectation: "Calling Autocomplete should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&s=1&i=\(kRegexClientID)&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C"), builder.create())

        self.constructor.autocomplete(forQuery: query) { (response) in }
        self.wait(for: builder.expectation)
    }
    
}
