//
//  RecommendationsResponseParserTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class RecommendationsResponseParserTests: XCTestCase {

    var parser: RecommendationsResponseParser!

    override func setUp() {
        super.setUp()
        self.parser = RecommendationsResponseParser()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRecommendationsParser_parsingNonJSONData_ThrowsAnException() {
        let failWithMessage = "Passing invalid JSON data should throw a CIOError.InvalidResponse"
        let invalidData = "a beautiful day".data(using: String.Encoding.utf8)!
        do {
            _ = try self.parser.parse(recommendationsResponseData: invalidData)
            XCTFail(failWithMessage)
        } catch let error as CIOError {
            XCTAssertEqual(error.errorType, .invalidResponse)
        } catch {
            XCTFail(failWithMessage)
        }
    }

    func testRecommendationsParser_ParsingJSONString_WithInvalidStructure_ThrowsAnException() {
        let failWithMessage = "Passing valid JSON with invalid structure should throw a CIOError.InvalidResponse"
        let validJSONData = "{ \"key\": \"value\" }".data(using: String.Encoding.utf8)!
        do {
            _ = try self.parser.parse(recommendationsResponseData: validJSONData)
            XCTFail(failWithMessage)
        } catch let error as CIOError {
            XCTAssertEqual(error.errorType, .invalidResponse)
        } catch {
            XCTFail(failWithMessage)
        }
    }

    func testRecommendationsParser_ParsingJSONString_HasCorrectResultCount() {
        let data = TestResource.load(name: TestResource.Response.recommendationsJSONFilename)
        do {
            let response = try self.parser.parse(recommendationsResponseData: data)
            XCTAssertEqual(response.results.count, TestResource.Response.numberOfResultsInRecommendationsResponse, "Number of parsed results should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testRecommendationsParser_ParsingJSONString_HasCorrectPodInfo() {
        let data = TestResource.load(name: TestResource.Response.recommendationsJSONFilename)
        do {
            let response = try self.parser.parse(recommendationsResponseData: data)
            let pod = response.pod

            XCTAssertEqual(pod.id, "item_page_1", "Pod ID should match the JSON response")
            XCTAssertEqual(pod.displayName, "You may also like", "Pod Display Name should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testRecommendationsParser_ParsingJSONString_HasRequestObject() {
        let data = TestResource.load(name: TestResource.Response.recommendationsJSONFilename)
        do {
            let response = try self.parser.parse(recommendationsResponseData: data)
            let requestJson = response.request

            XCTAssertEqual(requestJson["item_id"] as? String, "138250149", "Valid item_id should be correctly parsed")
            XCTAssertEqual(requestJson["pod_id"] as? String, "item_page_1", "Valid pod_id should be correctly parsed")
            XCTAssertEqual(requestJson["num_results"] as? Int, 10, "Valid num_results should be correctly parsed")
            XCTAssertNotNil(requestJson["fmt_options"] as? JSONObject, "Valid fmtOptions should be correctly parsed")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testRecommendationsParser_PrasingJSONString_HasValidResultData() {
        let data = TestResource.load(name: TestResource.Response.recommendationsJSONFilename)
        do {
            let response = try self.parser.parse(recommendationsResponseData: data)
            let result = response.results.first!

            XCTAssertEqual(result.data.id, "117100030", "Item ID should match the JSON response")
            XCTAssertEqual(result.value, "Gold Medal Flour All-Purpose - 5 Lb", "Item Value (Name) should match the JSON response")
            XCTAssertEqual(result.data.groups.count, 1, "Groups count should match the JSON response")
            XCTAssertEqual(result.strategy.id, "alternative_items", "Strategy ID should match the JSON response")
        } catch {
            XCTFail("Parser should never throw an exception when a valid JSON string is passed.")
        }
    }

    func testRecommendationPageParser_ParsesPerPodResultIDs() {
        let json = """
        {
          "request": { "page_id": "pdp_b2c", "item_id": "product-123" },
          "response": {
            "page_id": "pdp_b2c",
            "display_name": "PDP - B2C",
            "page_type": "pdp",
            "pods": [
              {
                "pod_id": "similar_items",
                "request": { "item_id": "product-123", "num_results": 12 },
                "response": {
                  "results": [ { "data": { "id": "product-987" }, "value": "Red Running Shoe", "is_slotted": false, "labels": {}, "strategy": { "id": "alternative_items" } } ],
                  "total_num_results": 1,
                  "pod": { "id": "similar_items", "display_name": "Similar Items" }
                },
                "result_id": "a1b2c3d4-0000-0000-0000-000000000001"
              },
              {
                "pod_id": "complete_the_look",
                "request": { "item_id": "product-123", "num_results": 8 },
                "response": { "results": [], "total_num_results": 0 },
                "result_id": "a1b2c3d4-0000-0000-0000-000000000002"
              }
            ]
          },
          "result_id": "a1b2c3d4-0000-0000-0000-0000000000ff"
        }
        """
        do {
            let page = try RecommendationPageResponseParser().parse(recommendationPageResponseData: json.data(using: .utf8)!)

            XCTAssertEqual(page.resultID, "a1b2c3d4-0000-0000-0000-0000000000ff")
            XCTAssertEqual(page.pageID, "pdp_b2c")
            XCTAssertEqual(page.pageType, "pdp")
            XCTAssertEqual(page.pods.map { $0.podID }, ["similar_items", "complete_the_look"])
            XCTAssertEqual(page.pods[0].resultID, "a1b2c3d4-0000-0000-0000-000000000001")
            XCTAssertEqual(page.pods[0].response.resultID, "a1b2c3d4-0000-0000-0000-000000000001")
            XCTAssertEqual(page.pods[0].response.pod.id, "similar_items")
            XCTAssertEqual(page.pods[0].response.results.count, 1)
            XCTAssertEqual(page.pods[0].response.request["pod_id"] as? String, "similar_items")
            XCTAssertEqual(page.pods[1].resultID, "a1b2c3d4-0000-0000-0000-000000000002")
            XCTAssertEqual(page.pods[1].response.pod.id, "complete_the_look", "A pod without a pod object falls back to its pod_id")
            XCTAssertEqual(page.pods[1].response.results.count, 0)
            XCTAssertFalse(page.pods.contains { $0.resultID == page.resultID })
        } catch {
            XCTFail("Parser should not throw for a valid page response: \(error)")
        }
    }

    func testRecommendationPageParser_WithoutPods_ThrowsAnException() {
        let data = "{ \"response\": {} }".data(using: .utf8)!
        XCTAssertThrowsError(try RecommendationPageResponseParser().parse(recommendationPageResponseData: data)) { error in
            XCTAssertEqual((error as? CIOError)?.errorType, .invalidResponse)
        }
    }
}
