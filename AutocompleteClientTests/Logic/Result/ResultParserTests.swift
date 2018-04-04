//
//  ResultParserTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class ResultParserTests: XCTestCase {

    var responseParser: CIOResponseParser!

    override func setUp() {
        super.setUp()
        self.responseParser = CIOResponseParser()
    }

    func test_ParsingNonJSONData_ThrowsAnException() {
        let failWithMessage = "Passing invalid JSON data should throw a CIOError.InvalidResponse"
        let invalidData = "a beautiful day".data(using: String.Encoding.utf8)!
        do {
            _ = try responseParser.parse(autocompleteResponseData: invalidData)
            XCTFail(failWithMessage)
        } catch CIOError.invalidResponse {
            XCTAssertTrue(true)
        } catch {
            XCTFail(failWithMessage)
        }
    }

    func test_ParsingJSONString_WithInvalidStructure_ThrowsAnException() {
        let failWithMessage = "Passing valid JSON with invalid structure should throw a CIOError.InvalidResponse"
        let validJSONData = "{ \"key\": \"value\" }".data(using: String.Encoding.utf8)!
        do {
            _ = try responseParser.parse(autocompleteResponseData: validJSONData)
            XCTFail(failWithMessage)
        } catch CIOError.invalidResponse {
            XCTAssertTrue(true)
        } catch {
            XCTFail(failWithMessage)
        }
    }

    func test_ParsingMultipleSectionJSONString_HasCorrectSectionCount() {
        let data = TestResource.load(name: TestResource.Response.multipleSectionsJSONFilename)
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            XCTAssertEqual(response.sections.count, TestResource.Response.numberOfSectionsInMultipleSectionsResponse, "Number of parsed sections should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func test_ParsingSingleSectionJSONString_HasSingleSection() {
        let data = TestResource.load(name: TestResource.Response.singleSectionJSONFilename)
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            XCTAssertEqual(response.sections.count, 1, "Number of parsed sections should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func test_ParsingMultipleGroupsJSONString_HasCorrectItemCount() {
        let data = TestResource.load(name: TestResource.Response.multipleGroupsJSONFilename)
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            
            if let results = response.sections[Constants.Response.singleSectionResultField]{
                XCTAssertEqual(results.count, TestResource.Response.numberOfGroupsInMultipleSectionsResponse+1, "Number of parsed items with multiple groups should match the number of groups plus one.")
            }else{
                XCTFail("Results incorrectly parsed, no results array for key \(Constants.Response.singleSectionResultField) when server returns a single section")
            }
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }
    
    func test_ParsingSpecificSectionInMultisectionJSON_ReturnsCorrectResults(){
        let data = TestResource.load(name: TestResource.Response.multipleSectionsJSONFilename)
        
        // let's only parse items from the 'standard' section
        let sectionName = "standard"
        
        // create mock delegate
        let del = MockResponseParserDelegate()
        del.shouldParseResultsInSection = { name in
            return name.lowercased() == sectionName
        }
        self.responseParser.delegate = del
        
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            
            XCTAssertNotNil(response.sections[sectionName], "Results should include the section with the filtered name.")
            XCTAssertEqual(response.sections.count, 1, "Results should only include the section with the filtered name.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }
    
    func test_ParsingNonexistingSectionInMultisectionJSON_ReturnsNoResults(){
        let data = TestResource.load(name: TestResource.Response.multipleSectionsJSONFilename)
        
        // let's pass a non existing section name
        let sectionName = "non-existing-section-name"
        
        // create mock delegate
        let del = MockResponseParserDelegate()
        del.shouldParseResultsInSection = { name in
            return name.lowercased() == sectionName
        }
        self.responseParser.delegate = del
        
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            
            XCTAssertEqual(response.sections.count, 0, "Results should be empty if the specified section doesn't exist within the JSON response.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }
    
    func test_ParsingValidJSONReturnsGroupResultsOnlyForFirstItem_IfDelegateMethodNotImplemented(){
        let data = TestResource.load(name: TestResource.Response.multipleGroupsJSONFilename2)
        
        // create mock delegate
        let del = MockResponseParserDelegate()
        del.shouldParseResultInGroup = nil
        responseParser.delegate = del
        
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            let searchSuggestions = response.getSearchSuggestions()!
            
            let firstItemResult = searchSuggestions.first!.autocompleteResult
            
            let resultsContainingFirstItem = searchSuggestions.filter({ item in item.autocompleteResult == firstItemResult })
            XCTAssertEqual(resultsContainingFirstItem.count, 3, "There should be 3 group results returned for the first item.")
            
            let resultsContainingNonNilGroupResults = searchSuggestions.filter({ item in item.autocompleteResult != firstItemResult })
                                                                       .filter{ $0.group != nil }
            
            XCTAssertEqual(resultsContainingNonNilGroupResults.count, 0, "There should be no items with non nil group past the first item parsed.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }
    
    func test_ParsingValidJSONReturnsGroupResultsForMultipleItems_IfDelegateMethodReturnsTrue(){
        let data = TestResource.load(name: TestResource.Response.multipleGroupsJSONFilename2)
        
        // create mock delegate
        let del = MockResponseParserDelegate()
        del.shouldParseResultInGroup = { _,_ in return true}
        responseParser.delegate = del
        
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            let searchSuggestions = response.getSearchSuggestions()!
            
            let suggestionsContainingNonNilGroup = searchSuggestions.filter{ $0.group != nil }
            
            // first item contains two group results, so we're looking for more than two results where group is not nil
            XCTAssertGreaterThan(suggestionsContainingNonNilGroup.count, 2, "There should be at least one item with non nil group past the first item parsed.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }
    
    func test_ParsingValidJSONReturnsNoGroupResults_IfDelegateMethodReturnsFalse(){
        let data = TestResource.load(name: TestResource.Response.multipleGroupsJSONFilename2)
        
        // create mock delegate
        let del = MockResponseParserDelegate()
        del.shouldParseResultInGroup = { _,_ in return false }
        responseParser.delegate = del
        
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            let searchSuggestions = response.getSearchSuggestions()!
            
            let suggestionsContainingNonNilGroup = searchSuggestions.filter{ $0.group != nil }
            
            // first item contains two group results, so we're looking for more than two results where group is not nil
            XCTAssertEqual(suggestionsContainingNonNilGroup.count, 0, "There should be no items with non nil group if the delegate returns false.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }
}
