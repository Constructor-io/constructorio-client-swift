//
//  AutocompleteTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 8/22/18.
//  Copyright © 2018 xd. All rights reserved.
//

import XCTest
import Mockingjay

@testable import ConstructorAutocomplete

class AutocompleteTests: XCTestCase {
    
    var constructor: ConstructorIO!
    
    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(autocompleteKey: TestConstants.testAutocompleteKey, clientID: nil)
        self.mockingjayRemoveStubOnTearDown = true
    }
    
    func testCallingAutocomplete_CreatesValidRequest(){
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)
        
        let matcher = CIOMatcher().URL(Constants.Query.baseURLString)
            .httpMethod(.get)
            .pathComponent(Constants.TrackAutocomplete.pathString) // autocomplete path component
            .pathComponent(term)                                   // searchTerm path component
            .attachAutocompleteKeyParameter()                      // autocomplete key
            .create()
        
        let builder = CIOBuilder(expectation: "Calling Autocomplete should send a valid request.", builder: http(200))
        stub(matcher, builder.create())
        
        self.constructor.autocomplete(forQuery: query) { (response) in }
        self.wait(for: builder.expectation)
    }
    
}
