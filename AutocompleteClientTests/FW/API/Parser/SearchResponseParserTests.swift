//
//  SearchResponseParserTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

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
        } catch let error as CIOError {
            XCTAssertEqual(error.errorType, .invalidResponse)
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
        } catch let error as CIOError {
            XCTAssertEqual(error.errorType, .invalidResponse)
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

    func testSearchParser_ParsingJSONString_HasCorrectGroupsCount() {
        let data = TestResource.load(name: TestResource.Response.searchJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            let result = response.groups.first!

            XCTAssertEqual(result.children.count, 5, "Number of parsed variations should match the JSON response")
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
                    XCTAssertNotNil(variation.data.metadata[key], "Parameter \(key) should be present in the parsed dictionary.")
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

            XCTAssertNotNil(variation.data.url, "Valid URL should be correctly parsed.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_ParsingJSONString_parsesValidVariationImageURL() {
        let data = TestResource.load(name: TestResource.Response.multipleVariationsJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            let variation = response.results.first!.variations.first!

            XCTAssertNotNil(variation.data.imageURL, "Valid Image URL should be correctly parsed.")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_ParsingJSONString_ParsesRefinedContent() {
        let data = TestResource.load(name: TestResource.Response.searchJSONRefinedContentFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            let refinedContentData = response.refinedContent.first!.data

            XCTAssertNotNil(refinedContentData["header"], "Valid header should be correctly parsed")
            XCTAssertNotNil(refinedContentData["body"], "Valid body should be correctly parsed")
            XCTAssertNotNil(refinedContentData["altText"], "Valid altText should be correctly parsed")
            XCTAssertNotNil(refinedContentData["assetUrl"], "Valid assetUrl should be correctly parsed")
            XCTAssertNotNil(refinedContentData["mobileAssetUrl"], "Valid mobileAssetUrl should be correctly parsed")
            XCTAssertNotNil(refinedContentData["mobileAssetAltText"], "Valid mobileAssetAltText should be correctly parsed")
            XCTAssertNotNil(refinedContentData["ctaLink"], "Valid ctaLink should be correctly parsed")
            XCTAssertNotNil(refinedContentData["ctaText"], "Valid ctaText should be correctly parsed")

        } catch {
            XCTFail("Parse should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_parsingRequestObjectAsJson_hasRelevantFields() {
        let data = TestResource.load(name: TestResource.Response.searchJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            let requestJson = response.request

            let fmtOptions = requestJson["fmt_options"] as? JSONObject
            let groupsMaxDepth = fmtOptions?["groups_max_depth"]
            let groupsStart = fmtOptions?["groups_start"]

            XCTAssertNotNil(fmtOptions, "Valid fmtOptions should be correctly parsed")
            XCTAssertEqual(groupsMaxDepth as? Int, Optional(1), "Valid groupsMaxDepth should be correctly parsed")
            XCTAssertEqual(groupsStart as? String, "current", "Valid groupsStart should be correctly parsed")
            XCTAssertEqual(requestJson["num_results_per_page"] as? Int, Optional(24), "Valid numResults should be correctly parsed")
            XCTAssertEqual(requestJson["page"] as? Int, Optional(1), "Valid page should be correctly parsed")
            XCTAssertEqual(requestJson["section"] as? String, "Products", "Valid section should be correctly parsed")
            XCTAssertEqual(requestJson["sort_by"] as? String, "relevance", "Valid sortBy should be correctly parsed")
            XCTAssertEqual(requestJson["sort_order"] as? String, "descending", "Valid sortOrder should be correctly parsed")
            XCTAssertEqual(requestJson["term"] as? String, "banana", "Valid term should be correctly parsed")
            XCTAssertEqual(requestJson["us"] as? [String], ["COUNTRY_US"], "Valid userSegment should be correctly parsed")

        } catch {
            XCTFail("Parse should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testSearchParser_ParsingJSONString_ParsingValidFacetFields() {
        let data = TestResource.load(name: TestResource.Response.searchJSONFilename)
        do {
            let response = try self.parser.parse(searchResponseData: data)
            let facetData = response.facets.first?.data as? JSONObject

            XCTAssertNotNil(facetData, "Valid data object should be correctly parsed")
            XCTAssertEqual(facetData?["url"] as? String, "example.com", "Valid data url value should be correctly parsed")

            XCTAssertEqual(response.facets.first?.hidden, true, "Valid hidden value should be correctly parsed")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }
}
