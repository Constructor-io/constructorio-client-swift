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
}
