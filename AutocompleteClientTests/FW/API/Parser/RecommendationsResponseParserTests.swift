//
//  RecommendationsResponseParserTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
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
}
