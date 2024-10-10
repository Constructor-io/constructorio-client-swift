//
//  CIOAutocompleteResponseParserTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class CIOAutocompleteResponseParserTests: XCTestCase {

    var responseParser: CIOAutocompleteResponseParser!

    override func setUp() {
        super.setUp()
        self.responseParser = CIOAutocompleteResponseParser()
    }

    func testParsingNonJSONData_ThrowsAnException() {
        let failWithMessage = "Passing invalid JSON data should throw a CIOError.InvalidResponse"
        let invalidData = "a beautiful day".data(using: String.Encoding.utf8)!
        do {
            _ = try responseParser.parse(autocompleteResponseData: invalidData)
            XCTFail(failWithMessage)
        } catch let error as CIOError {
            XCTAssertEqual(error.errorType, .invalidResponse)
        } catch {
            XCTFail(failWithMessage)
        }
    }

    func testParsingJSONString_WithInvalidStructure_ThrowsAnException() {
        let failWithMessage = "Passing valid JSON with invalid structure should throw a CIOError.InvalidResponse"
        let validJSONData = "{ \"key\": \"value\" }".data(using: String.Encoding.utf8)!
        do {
            _ = try responseParser.parse(autocompleteResponseData: validJSONData)
            XCTFail(failWithMessage)
        } catch let error as CIOError {
            XCTAssertEqual(error.errorType, .invalidResponse)
        } catch {
            XCTFail(failWithMessage)
        }
    }

    func testParsingMultipleSectionJSONString_HasCorrectSectionCount() {
        let data = TestResource.load(name: TestResource.Response.multipleSectionsJSONFilename)
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            XCTAssertEqual(response.sections.count, TestResource.Response.numberOfSectionsInMultipleSectionsResponse, "Number of parsed sections should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testParsingMultipleSectionJSONString_HasCorrectRequestObject() {
        let data = TestResource.load(name: TestResource.Response.multipleSectionsJSONFilename)
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            let requestJson = response.request

            XCTAssertEqual(response.sections.count, TestResource.Response.numberOfSectionsInMultipleSectionsResponse, "Number of parsed sections should match the JSON response")
            XCTAssertEqual(requestJson["num_results_per_page"] as? Int, Optional(20), "Valid numResults should be correctly parsed")
            XCTAssertEqual(requestJson["page"] as? Int, Optional(1), "Valid page should be correctly parsed")
            XCTAssertEqual(requestJson["section"] as? String, "Products", "Valid section should be correctly parsed")
            XCTAssertEqual(requestJson["sort_by"] as? String, "relevance", "Valid sortBy should be correctly parsed")
            XCTAssertEqual(requestJson["sort_order"] as? String, "descending", "Valid sortOrder should be correctly parsed")
            XCTAssertEqual(requestJson["term"] as? String, "", "Valid term should be correctly parsed")
            XCTAssertNotNil(requestJson["features"], "Valid features should be correctly parsed")
            XCTAssertNotNil(requestJson["feature_variants"], "Valid featureVariants should be correctly parsed")
            XCTAssertNotNil(requestJson["searchandized_items"], "Valid searchandizedItems should be correctly parsed")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testParsingSingleSectionJSONString_HasSingleSection() {
        let data = TestResource.load(name: TestResource.Response.singleSectionJSONFilename)
        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            XCTAssertEqual(response.sections.count, 1, "Number of parsed sections should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testParsingMultipleGroupsJSONString_HasCorrectItemCount() {
        let data = TestResource.load(name: TestResource.Response.multipleGroupsJSONFilename)
        do {
            responseParser.maxGroups = 10
            let response = try responseParser.parse(autocompleteResponseData: data)
            if let results = response.sections[Constants.Response.singleSectionResultField] {
                XCTAssertEqual(results.count, TestResource.Response.numberOfGroupsInMultipleSectionsResponse + 1, "Number of parsed items with multiple groups should match the number of groups plus one.")
            } else {
                XCTFail("Results incorrectly parsed, no results array for key \(Constants.Response.singleSectionResultField) when server returns a single section")
            }
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testParsingValidJSONReturnsGroupResultsForMultipleItems_IfDelegateMethodReturnsTrue() {
        let data = TestResource.load(name: TestResource.Response.multipleSectionsJSONFilename)

        // create mock delegate
        let del = MockResponseParserDelegate()
        del.shouldParseResultInGroup = { _, _ in return true }
        responseParser.delegate = del

        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            let searchSuggestions = response.getSearchSuggestions()!

            let suggestionsContainingNonNilGroup = searchSuggestions.filter { $0.group != nil }

            // first item contains two group results, so we're looking for more than two results where group is not nil
            XCTAssertGreaterThan(suggestionsContainingNonNilGroup.count, 2, "There should be at least one item with non nil group past the first item parsed.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testParsingValidJSONReturnsNoGroupResults_IfDelegateMethodReturnsFalse() {
        let data = TestResource.load(name: TestResource.Response.multipleSectionsJSONFilename)

        // create mock delegate
        let del = MockResponseParserDelegate()
        del.shouldParseResultInGroup = { _, _ in return false }
        responseParser.delegate = del

        do {
            let response = try responseParser.parse(autocompleteResponseData: data)
            let searchSuggestions = response.getSearchSuggestions()!

            let suggestionsContainingNonNilGroup = searchSuggestions.filter { $0.group != nil }

            // first item contains two group results, so we're looking for more than two results where group is not nil
            XCTAssertEqual(suggestionsContainingNonNilGroup.count, 0, "There should be no items with non nil group if the delegate returns false.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }
    
    func testParsingMultipleGroupsJSONString_HasCorrectItemCountWithZeroMaxGroups() {
        let data = TestResource.load(name: TestResource.Response.multipleGroupsJSONFilename)
        do {
            responseParser.maxGroups = 0
            let response = try responseParser.parse(autocompleteResponseData: data)
            if let results = response.sections[Constants.Response.singleSectionResultField] {
                XCTAssertEqual(results.count, 1, "Number of parsed items with multiple groups should not include the number of groups")
            } else {
                XCTFail("Results incorrectly parsed, no results array for key \(Constants.Response.singleSectionResultField) when server returns a single section")
            }
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }
}
