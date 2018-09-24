//
//  AutocompleteTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 8/22/18.
//  Copyright © 2018 xd. All rights reserved.
//

import XCTest
@testable import ConstructorAutocomplete

class AutocompleteTests: XCTestCase {
    
    var constructor: ConstructorIO!
    
    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(autocompleteKey: TestConstants.testAutocompleteKey, clientID: nil)
    }
    
    func testCallingAutocomplete_CreatesValidRequest(){
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)
        
        let builder = CIOBuilder(expectation: "Calling Autocomplete should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&s=1&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C"), builder.create())

        self.constructor.autocomplete(forQuery: query) { (response) in }
        self.wait(for: builder.expectation)
    }
    
    func testCallingAutocompleteReturnsError(error: CIOError, forHTTPStatusCode statusCode: Int32){
        let expectation = self.expectation(description: "If tracking call returns status code \(statusCode), the error should be delegated to the completion handler")
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)
        
        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&s=1&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C"), http(statusCode))
        
        self.constructor.autocomplete(forQuery: query) { (response) in
            if let e = response.error as? CIOError{
                XCTAssertEqual(e, error, "If autocomplete call returns status code \(statusCode), the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        }
        self.wait(for: expectation)
    }
    
    func testCallingAutocomplete_WithNoConnectivity_ReturnsCorrectError(){
        let expectation = self.expectation(description: "Calling autocomplete with no connectvity should return noConnectivity CIOError.")
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)
        
        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&s=1&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C"), noConnectivity())
        
        self.constructor.autocomplete(forQuery: query) { (response) in
            if let error = response.error as? CIOError{
                XCTAssertEqual(CIOError.noConnection, error, "Returned error from network client should be delegated as an error of type CIOError.noConnection.")
                expectation.fulfill()
            }
        }
        self.wait(for: expectation)
    }
    
    func testCallingAutocomplete_Status400_ReturnsCorrectError(){
        self.testCallingAutocompleteReturnsError(error: CIOError.badRequest, forHTTPStatusCode: 400)
    }
    
    func testCallingAutocomplete_Status500_ReturnsCorrectError(){
        self.testCallingAutocompleteReturnsError(error: CIOError.internalServerError, forHTTPStatusCode: 500)
    }
    
}
