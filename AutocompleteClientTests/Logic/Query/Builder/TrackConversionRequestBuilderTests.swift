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
        let tracker = CIOTrackConversionData(searchTerm: searchTerm)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
    }

    func testTrackConversionBuilder_withItemName() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
    }

    func testTrackConversionBuilder_withSectionName() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, sectionName: sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
    }
    
    func testTrackConversionBuilder_withRevenue() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, revenue: revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("revenue=\(revenue)"), "URL should contain the revenue parameter.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
    }

    func testTrackConversionBuilder_withNoSectionSpecified_hasNoSectionName() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        
        XCTAssertTrue(!request.url!.absoluteString.contains("\(Constants.TrackAutocomplete.autocompleteSection)="), "URL shouldn't contain the default autocomplete section if the section name is not passed.")
    }
    
    func testTrackConversionBuilder_AllFields() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, sectionName: sectionName, revenue: revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(request.url!.absoluteString.contains("revenue=\(revenue)"), "URL should contain the revenue parameter.")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
    }
}
