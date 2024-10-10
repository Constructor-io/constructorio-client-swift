//
//  TrackPurchaseRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackPurchaseRequestBuilderTests: XCTestCase {

    fileprivate let revenue: Double = 2.5
    fileprivate let testACKey = "testKey123213"
    fileprivate let orderID = "234-4532"
    fileprivate let customerIDs = ["custIDq3éû qd", "womp womp"]
    fileprivate let sectionName = "some section name@"

    fileprivate var encodedCustomerID1: String = ""
    fileprivate var encodedCustomerID2: String = ""
    fileprivate var encodedSectionName: String = ""

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedCustomerID1 = "customer_ids=" + customerIDs[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedCustomerID2 = "customer_ids=" + customerIDs[1].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedSectionName = self.sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackPurchaseBuilder() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }
    
    func testTrackPurchaseBuilder_WithAnalyticsTags() {
        let analyticsTags = ["test": "testing", "version": "123"]
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs, analyticsTags: analyticsTags)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let analyticsTagsPayload = payload?["analytics_tags"] as? [String: String] ?? [:]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(analyticsTagsPayload, analyticsTags)
    }

    func testTrackPurchaseBuilder_WithCustomBaseURL() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs)
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: customBaseURL)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix(customBaseURL))
    }

    func testTrackPurchaseBuilder_WithSectionName() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs, sectionName: self.sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertTrue(url.contains("section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }

    func testTrackPurchaseBuilder_WithRevenue() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs, sectionName: self.sectionName, revenue: self.revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertEqual(payload?["revenue"] as? Double, revenue)
    }

    func testTrackPurchaseBuilder_WithFloatingPointRevenue() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs, sectionName: self.sectionName, revenue: 12.345678)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertEqual(payload?["revenue"] as? Double, 12.35, "Incorrect rounding of floating point revenue.")
    }

    func testTrackPurchaseBuilder_WithOrderID() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs, sectionName: self.sectionName, orderID: self.orderID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertEqual(payload?["order_id"] as? String, orderID)
    }

    func testTrackPurchaseBuilder_WithLargeItemsArray() {
        let tracker = CIOTrackPurchaseData(customerIDs: Array(repeating: "itemID", count: 150), sectionName: self.sectionName, orderID: self.orderID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let items = payload?["items"] as? [[String: String]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertEqual(items.count, 100)
    }

    func testTrackPurchaseBuilder_WithItemsParam() {
        let items = [
            CIOItem(customerID: "custID1", variationID: "varID1"),
            CIOItem(customerID: "custID2", variationID: "varID2"),
            CIOItem(customerID: "custID3", variationID: "varID3")
        ]
        let tracker = CIOTrackPurchaseData(items: items, sectionName: self.sectionName, orderID: self.orderID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let purchasedItems = payload?["items"] as? [[String: String]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertEqual(purchasedItems.count, 3)
        XCTAssertEqual(purchasedItems[0]["item_id"], items[0].customerID)
        XCTAssertEqual(purchasedItems[0]["variation_id"], items[0].variationID)
    }

    func testTrackPurchaseBuilder_WithItemsContainingQuantityParam() {
        let items = [
            CIOItem(customerID: "custID1", variationID: "varID1", quantity: 2),
            CIOItem(customerID: "custID2", variationID: "varID2", quantity: 3)
        ]
        let tracker = CIOTrackPurchaseData(items: items, sectionName: self.sectionName, orderID: self.orderID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let purchasedItems = payload?["items"] as? [[String: String]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertEqual(purchasedItems.count, 5)
        XCTAssertEqual(purchasedItems[0]["item_id"], items[0].customerID)
        XCTAssertEqual(purchasedItems[0]["variation_id"], items[0].variationID)
        XCTAssertEqual(purchasedItems[1]["item_id"], items[0].customerID)
        XCTAssertEqual(purchasedItems[1]["variation_id"], items[0].variationID)
        XCTAssertEqual(purchasedItems[2]["item_id"], items[1].customerID)
        XCTAssertEqual(purchasedItems[2]["variation_id"], items[1].variationID)
    }
}
