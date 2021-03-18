//
//  ConstructorIOTrackConversionTests
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import OHHTTPStubs
import ConstructorAutocomplete

class ConstructorIOTrackConversionTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackConversion() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/conversion?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)&section=Products&term=corn&type=add_to_cart"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackConversion_NoTerm() {
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a default section name and default term.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/conversion?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)&section=Products&term=TERM_UNKNOWN&type=add_to_cart"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: nil, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackConversion_EmptyTerm() {
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a default section name and default term.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/conversion?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)&section=Products&term=TERM_UNKNOWN&type=add_to_cart"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: "", sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackConversion_WithSection() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/conversion?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)&section=Search%20Suggestions&term=corn&type=add_to_cart"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }
    
    func testTrackConversion_WithType() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let conversionType = "like"
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a type.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/conversion?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)&section=Products&term=corn&type=\(conversionType)"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, conversionType: conversionType)
        self.wait(for: builder.expectation)
    }

    func testTrackConversion_WithSectionFromConfig() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let sectionName = "section321"
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/conversion?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)&section=\(sectionName)&term=corn&type=add_to_cart"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        let constructor = TestConstants.testConstructor(config)
        constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }

    func testTrackConversion_With400() {
        let expectation = self.expectation(description: "Calling trackConversion with 400 should return badRequest CIOError.")
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/conversion?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)&section=Products&term=corn&type=add_to_cart"), http(400))
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: nil, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackConversion_With500() {
        let expectation = self.expectation(description: "Calling trackConversion with 500 should return internalServerError CIOError.")
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/conversion?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)&section=Products&term=corn&type=add_to_cart"), http(500))
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: nil, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackConversion_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackConversion with no connectvity should return noConnectivity CIOError.")
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/conversion?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)&section=Products&term=corn&type=add_to_cart"), noConnectivity())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: nil, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
