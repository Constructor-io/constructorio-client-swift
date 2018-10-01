//
//  TrackSearchResultClickRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackSearchResultClickRequestBuilderTests: XCTestCase {
    
    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "test search term"
    fileprivate let itemID = "some item id"
    fileprivate let sectionName = "some section name@"
    
    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedItemID: String = ""
    fileprivate var encodedSectionName: String = ""
    
    fileprivate var builder: RequestBuilder!
    
    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedItemID = itemID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedSectionName = self.sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey)
    }
    
    func testTrackSearchResultClickBuilder() {
        let tracker = CIOTrackSearchResultClickData(searchTerm: searchTerm, itemID: itemID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/click_through?"))
        XCTAssertTrue(url.contains("item_id=\(encodedItemID)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
    }
    
    func testTrackSearchResultClickBuilder_withSectionName() {
        let tracker = CIOTrackSearchResultClickData(searchTerm: searchTerm, itemID: itemID, sectionName: sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/click_through?"))
        XCTAssertTrue(url.contains("item_id=\(encodedItemID)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
    }
}

