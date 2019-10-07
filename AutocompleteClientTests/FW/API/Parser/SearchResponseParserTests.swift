//
//  SearchResponseParserTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class SearchResponseParserTests: XCTestCase {

    var parser: SearchResponseParser!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.parser = SearchResponseParser()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSearchParser_parsingNonJSONData_ThrowsAnException() {
        let failWithMessage = "Passing invalid JSON data should throw a CIOError.InvalidResponse"
        let invalidData = "a beautiful day".data(using: String.Encoding.utf8)!
        do {
            _ = try self.parser.parse(searchResponseData: invalidData)
            XCTFail(failWithMessage)
        } catch CIOError.invalidResponse {
            XCTAssertTrue(true)
        } catch {
            XCTFail(failWithMessage)
        }
    }

    func testSearchParser_ParsingJSONString_WithInvalidStructure_ThrowsAnException() {
        let failWithMessage = "Passing valid JSON with invalid structure should throw a CIOError.InvalidResponse"
        let validJSONData = "{ \"key\": \"value\" }".data(using: String.Encoding.utf8)!
        do {
            _ = try self.parser.parse(searchResponseData: validJSONData)
            XCTFail(failWithMessage)
        } catch CIOError.invalidResponse {
            XCTAssertTrue(true)
        } catch {
            XCTFail(failWithMessage)
        }
    }

    func testSearchParser_ParsingJSONString_HasCorrectFacetCount() {
        let data = TestResource.load(name: TestResource.Response.searchJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            XCTAssertEqual(response.facets.count, TestResource.Response.numberOfFacetsInSearchResponse, "Number of parsed facets should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_ParsingJSONString_HasCorrectFacetOptionsCount() {
        let data = TestResource.load(name: TestResource.Response.searchJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            XCTAssertEqual(response.facets.first!.options.count, TestResource.Response.numberOfFacetsOptionsInSearchResponseResult1, "Number of parsed facet options should match the JSON response")
            XCTAssertEqual(response.facets[1].options.count, TestResource.Response.numberOfFacetsOptionsInSearchResponseResult2, "Number of parsed facet options should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_ParsingJSONString_HasCorrectResultCount() {
        let data = TestResource.load(name: TestResource.Response.searchJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            XCTAssertEqual(response.results.count, TestResource.Response.numberOfResultsInSearchResponse, "Number of parsed results should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_ParsingJSONString_HasCorrectVariationCount() {
        let data = TestResource.load(name: TestResource.Response.multipleVariationsJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            let result = response.results.first!

            XCTAssertEqual(result.variations.count, TestResource.Response.multipleVariationsCount, "Number of parsed variations should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_ParsingJSONString_CorrectlyDiscardsInvalidVariations() {
        let data = TestResource.load(name: TestResource.Response.multipleInvalidVariationsJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            let result = response.results.first!

            XCTAssertEqual(result.variations.count, TestResource.Response.multipleInvalidVariationsValidVariationCount, "Number of parsed variations should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_ParsingJSONString_parsesVariationCustomData() {
        let data = TestResource.load(name: TestResource.Response.multipleVariationsWithCustomDataJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)

            let customDataKeys: [[String]] = [
                [],
                ["custom_bool"],
                ["custom_int", "custom_object"]
            ]

            let result = response.results.first!
            for (idx, variation) in result.variations.enumerated() {
                if idx >= customDataKeys.count { break }

                for key in customDataKeys[idx] {
                    XCTAssertNotNil(variation.data[key], "Parameter \(key) should be present in the parsed dictionary.")
                }
            }
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_ParsingJSONString_parsesValidVariationURL() {
        let data = TestResource.load(name: TestResource.Response.multipleVariationsJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            let variation = response.results.first!.variations.first!

            XCTAssertNotNil(variation.url, "Valid URL should be correctly parsed.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_ParsingJSONString_parsesValidVariationImageURL() {
        let data = TestResource.load(name: TestResource.Response.multipleVariationsJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            let variation = response.results.first!.variations.first!

            XCTAssertNotNil(variation.imageURL, "Valid Image URL should be correctly parsed.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

}
