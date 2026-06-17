//
//  TrackAgentResultViewRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackAgentResultViewRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let intent = "show me healthy snacks"
    fileprivate let searchResultID = "179b8a0e-3799-4a31-be87-127b06871de2"
    fileprivate let numResultsViewed = 5
    fileprivate let sectionName = "Products"
    fileprivate let intentResultID = "intent-result-123"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackAgentResultViewBuilder() {
        let tracker = CIOTrackAgentResultViewData(intent: intent, searchResultID: searchResultID, numResultsViewed: numResultsViewed)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/assistant_search_result_view?"))
        XCTAssertEqual(payload?["intent"] as? String, intent)
        XCTAssertEqual(payload?["search_result_id"] as? String, searchResultID)
        XCTAssertEqual(payload?["num_results_viewed"] as? Int, numResultsViewed)
        XCTAssertNil(payload?["items"])
        XCTAssertNil(payload?["intent_result_id"])
    }

    func testTrackAgentResultViewBuilder_WithItems() {
        let items = [
            CIOItem(customerID: "item1", variationID: "var1"),
            CIOItem(customerID: "item2")
        ]
        let tracker = CIOTrackAgentResultViewData(intent: intent, searchResultID: searchResultID, numResultsViewed: numResultsViewed, items: items, sectionName: sectionName, intentResultID: intentResultID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["section"] as? String, sectionName)
        XCTAssertEqual(payload?["intent_result_id"] as? String, intentResultID)

        let payloadItems = payload?["items"] as? [[String: String]] ?? []
        XCTAssertEqual(payloadItems.count, 2)
        XCTAssertEqual(payloadItems[0]["item_id"], "item1")
        XCTAssertEqual(payloadItems[0]["variation_id"], "var1")
        XCTAssertEqual(payloadItems[1]["item_id"], "item2")
        XCTAssertNil(payloadItems[1]["variation_id"])
    }

    func testTrackAgentResultViewBuilder_CapsItemsAt100() {
        let items = (1...150).map { CIOItem(customerID: "item\($0)") }
        let tracker = CIOTrackAgentResultViewData(intent: intent, searchResultID: searchResultID, numResultsViewed: numResultsViewed, items: items)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        let payloadItems = payload?["items"] as? [[String: String]] ?? []
        XCTAssertEqual(payloadItems.count, 100, "items should be capped at 100")
        XCTAssertEqual(payloadItems[0]["item_id"], "item1")
        XCTAssertEqual(payloadItems[99]["item_id"], "item100")
    }
}
