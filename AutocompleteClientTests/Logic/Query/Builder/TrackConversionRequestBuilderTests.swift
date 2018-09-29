//
//  RequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class RequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "testKey123213"
    fileprivate let searchTerm = "test search term"
    fileprivate let itemName = "some item name"
    fileprivate let itemID = "some item id"
    fileprivate let sectionName = "some section name@"
    fileprivate let revenue = 99999

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedItemName: String = ""
    fileprivate var encodedSectionName: String = ""

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedItemName = self.itemName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedSectionName = self.sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.builder = RequestBuilder(autocompleteKey: testACKey)
    }
    
    func testTrackConversionBuilder_onlySearchTerm() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemID: itemID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(url.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
    }

    func testTrackConversionBuilder_withItemName() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemID: itemID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(url.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
    }

    func testTrackConversionBuilder_withSectionName() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemID: itemID, sectionName: sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
    }
    
    func testTrackConversionBuilder_withRevenue() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemID: itemID, revenue: revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(url.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(url.contains("revenue=\(revenue)"), "URL should contain the revenue parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("_dt=\(requestDate)"), "URL should contain the request date")
    }

    func testTrackConversionBuilder_withNoSectionSpecified_hasNoSectionName() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemID: itemID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertTrue(!url.contains("\(Constants.TrackAutocomplete.autocompleteSection)="), "URL shouldn't contain the default autocomplete section if the section name is not passed.")
    }
    
    func testTrackConversionBuilder_AllFields() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemID: itemID, sectionName: sectionName, revenue: revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(url.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(url.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(url.contains("revenue=\(revenue)"), "URL should contain the revenue parameter.")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
    }
}
