//
//  BrowseResponseParserTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class BrowseResponseParserTests: XCTestCase {

    var parser: BrowseResponseParser!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.parser = BrowseResponseParser()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBrowseParser_parsingRequestObjectAsJson_hasRelevantFields() {
        let data = TestResource.load(name: TestResource.Response.browseJSONFilename)
        do {
            let response = try self.parser.parse(browseResponseData: data)
            let requestJson = response.request

            let fmtOptions = requestJson["fmt_options"] as? JSONObject
            let groupsMaxDepth = fmtOptions?["groups_max_depth"]
            let groupsStart = fmtOptions?["groups_start"]

            XCTAssertNotNil(fmtOptions, "Valid fmtOptions should be correctly parsed")
            XCTAssertEqual(groupsMaxDepth as? Int, Optional(1), "Valid groupsMaxDepth should be correctly parsed")
            XCTAssertEqual(groupsStart as? String, "current", "Valid groupsStart should be correctly parsed")
            XCTAssertEqual(requestJson["num_results_per_page"] as? Int, Optional(20), "Valid numResults should be correctly parsed")
            XCTAssertEqual(requestJson["page"] as? Int, Optional(1), "Valid page should be correctly parsed")
            XCTAssertEqual(requestJson["section"] as? String, "Products", "Valid section should be correctly parsed")
            XCTAssertEqual(requestJson["sort_by"] as? String, "relevance", "Valid sortBy should be correctly parsed")
            XCTAssertEqual(requestJson["sort_order"] as? String, "descending", "Valid sortOrder should be correctly parsed")
            XCTAssertEqual(requestJson["term"] as? String, "", "Valid term should be correctly parsed")
            XCTAssertEqual(requestJson["browse_filter_name"] as? String, "group_id", "Valid filterName should be correctly parsed")
            XCTAssertEqual(requestJson["browse_filter_value"] as? String, "BrandA", "Valid filterValue should be correctly parsed")
            XCTAssertNotNil(requestJson["features"], "Valid features should be correctly parsed")
            XCTAssertNotNil(requestJson["feature_variants"], "Valid featureVariants should be correctly parsed")
            XCTAssertNotNil(requestJson["searchandized_items"], "Valid searchandizedItems should be correctly parsed")

        } catch {
            XCTFail("Parse should never throw an exception when a valid JSON string is passed.")
        }
    }
    
    func testBrowseParser_ParsingJSONString_ParsesLabels() {
        let data = TestResource.load(name: TestResource.Response.browseJSONFilename)
        do {
            let response = try self.parser.parse(browseResponseData: data)
            let labels = response.results[0].labels
            let newArrivals = labels["__cnstrc_new_arrivals"] as! [String: Any]

            XCTAssertEqual(labels["is_sponsored"] as! Bool, true)
            XCTAssertEqual(newArrivals["display_name"] as! String, "New Arrival")
            XCTAssertEqual(newArrivals["test"] as! String, "test")

        } catch {
            XCTFail("Parse should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testBrowseParser_ParsingJSONString_ParsesRefinedContent() {
        let data = TestResource.load(name: TestResource.Response.browseJSONFilename)
        do {
            let response = try self.parser.parse(browseResponseData: data)
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
}
