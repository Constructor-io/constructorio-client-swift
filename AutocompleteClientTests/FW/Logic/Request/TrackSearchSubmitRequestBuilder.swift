//
//  TrackSearchSubmitRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackSearchSubmitRequestBuilderTests: XCTestCase {
    
    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "😃test ink[]"
    fileprivate let originalQuery = "testing#@#??!!asd"
    fileprivate let group = CIOGroup(displayName: "groupName1", groupID: "groupID2", path: "path/to/group")
    
    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedOriginalQuery: String = ""
    fileprivate var builder: RequestBuilder!
    
    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedOriginalQuery = originalQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey)
    }
    
    func testTrackSearchSubmitBuilder() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/search?"))
        XCTAssertTrue(url.contains("original_query=\(encodedOriginalQuery)"), "URL should contain the original query")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
    }
    
    func testTrackSearchSubmitBuilder_WithGroup() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, group: group)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertTrue(url.contains("group%5Bgroup_name%5D=groupName1"), "URL should contain a URL query item with group name if item in group")
        XCTAssertTrue(url.contains("group%5Bgroup_id%5D=groupID2"), "URL should contain a URL query item with group id if item in group")
    }
    
    func testTrackSearchSubmitBuilder_WithoutGroup() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, group: nil)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertFalse(url.contains("group%5Bgroup_name%5D"), "URL shouldn't contain a URL query item with group id if item outside a group")
        XCTAssertFalse(url.contains("group%5Bgroup_id%5D"), "URL shouldn't contain a URL query item with group name if item outside a group")
    }
}
