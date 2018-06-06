//
//  TrackAutocompleteClickRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackAutocompleteClickRequestBuilderTests: XCTestCase {
    
    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "😃test ink[]"
    fileprivate let clickedItemName = "testing#@#??!!asd"
    fileprivate let sectionName = "product"
    
    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedClickedItemName: String = ""
    fileprivate var encodedSectionName: String = ""
    fileprivate var builder: TrackAutocompleteClickRequestBuilder!
    
    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedClickedItemName = clickedItemName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedSectionName = sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    private func initializeClickTrackDataRequestWithNoSectionName() -> URLRequest{
        let tracker = CIOAutocompleteClickTrackData(searchTerm: searchTerm, clickedItemName: clickedItemName)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        return request
    }
    
    private func initializeClickTrackDataRequestWithSectionName() -> URLRequest{
        let tracker = CIOAutocompleteClickTrackData(searchTerm: searchTerm, clickedItemName: clickedItemName, sectionName: sectionName)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        return request
    }
    
    // with section name
    
    func testTrackACClickBuilder_sectionNameSpecified_selectType_containsEncodedClickItem() {
        let request = self.initializeClickTrackDataRequestWithSectionName()
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedClickedItemName)/select?"), "URL base string should contain the encoded clicked item name.")
    }
    
    func testTrackACClickBuilder_sectionNameSpecified_selectType_hasGetHTTPMethod() {
        let request = self.initializeClickTrackDataRequestWithSectionName()
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testTrackACClickBuilder_sectionNameSpecified_selectType_containsOriginalQuery() {
        let request = self.initializeClickTrackDataRequestWithSectionName()
        XCTAssertTrue(request.url!.absoluteString.contains("original_query=\(encodedSearchTerm)"), "URL should contain the original query")
    }
    
    func testTrackACClickBuilder_sectionNameSpecified_selectType_containsAutocompleteSection() {
        let request = self.initializeClickTrackDataRequestWithSectionName()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section")
    }
    
    func testTrackACClickBuilder_sectionNameSpecified_selectType_containsRequestDate() {
        let request = self.initializeClickTrackDataRequestWithSectionName()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
    }
    
    func testTrackACClickBuilder_sectionNameSpecified_selectType_containsVersionString() {
        let request = self.initializeClickTrackDataRequestWithSectionName()
        XCTAssertTrue(request.url!.absoluteString.contains("c=\(Constants.versionString())"), "URL should contain the version string")
    }
    
    func testTrackACClickBuilder_sectionNameSpecified_selectType_containsAutocompleteKey() {
        let request = self.initializeClickTrackDataRequestWithSectionName()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key")
    }
    
    // No section name
    
    func testTrackACClickBuilder_withNoSectionName_selectType_containsEncodedClickItem() {
        let request = self.initializeClickTrackDataRequestWithNoSectionName()
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedClickedItemName)/search?"), "URL base string should contain the encoded clicked item name.")
    }
    
    func testTrackACClickBuilder_withNoSectionName_selectType_hasGetHTTPMethod() {
        let request = self.initializeClickTrackDataRequestWithNoSectionName()
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testTrackACClickBuilder_withNoSectionName_selectType_containsOriginalQuery() {
        let request = self.initializeClickTrackDataRequestWithNoSectionName()
        XCTAssertTrue(request.url!.absoluteString.contains("original_query=\(encodedSearchTerm)"), "URL should contain the original query")
    }
    
    func testTrackACClickBuilder_withNoSectionName_selectType_containsRequestDate() {
        let request = self.initializeClickTrackDataRequestWithNoSectionName()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
    }
    
    func testTrackACClickBuilder_withNoSectionName_selectType_containsVersionString() {
        let request = self.initializeClickTrackDataRequestWithNoSectionName()
        XCTAssertTrue(request.url!.absoluteString.contains("c=\(Constants.versionString())"), "URL should contain the version string")
    }
    
    func testTrackACClickBuilder_withNoSectionName_selectType_containsAutocompleteKey() {
        let request = self.initializeClickTrackDataRequestWithNoSectionName()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key")
    }
    
    func testTrackACClickBuilder_withNoSectionName_selectType_containsTrackType() {
        let request = self.initializeClickTrackDataRequestWithNoSectionName()
        XCTAssertTrue(request.url!.absoluteString.contains("tr=click"), "URL should contain the track type")
    }
    
    func testTrackACClickBuilder_tappingOnItemWithGroup_SendsGroupNameAsQueryParameter() {
        let groupName = "groupName1"
        let groupID = "groupID2"
        let groupPath = "path/to/group"
        let group = CIOGroup(displayName: groupName, groupID: groupID, path: groupPath)
        
        let tracker = CIOAutocompleteClickTrackData(searchTerm: searchTerm, clickedItemName: clickedItemName, sectionName: nil, group: group)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        
        let containsGroupName = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.contains { (item) -> Bool in
            return item.name == Constants.TrackAutocompleteResultClicked.groupName && item.value! == groupName
        }
        XCTAssertTrue(containsGroupName, "URL should contain a URL query item with group name if item in group is tapped on.")
    }
    
    func testTrackACClickBuilder_tappingOnItemWithGroup_SendsGroupIDAsQueryParameter() {
        let groupName = "groupName1"
        let groupID = "groupID2"
        let groupPath = "path/to/group"
        let group = CIOGroup(displayName: groupName, groupID: groupID, path: groupPath)
        
        let tracker = CIOAutocompleteClickTrackData(searchTerm: searchTerm, clickedItemName: clickedItemName, sectionName: nil, group: group)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        
        let containsGroupID = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.contains { (item) -> Bool in
            return item.name == Constants.TrackAutocompleteResultClicked.groupID && item.value! == groupID
        }
        XCTAssertTrue(containsGroupID, "URL should contain a URL query item with group id if item in group is tapped on.")
    }
    
    func testTrackACClickBuilder_tappingOnItemWithNoGroup_DoesNotSendGroupIDAsQueryParameter() {
        let tracker = CIOAutocompleteClickTrackData(searchTerm: searchTerm, clickedItemName: clickedItemName, sectionName: nil, group: nil)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        
        let containsGroupID = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.contains { (item) -> Bool in
            return item.name == Constants.TrackAutocompleteResultClicked.groupID
        }
        XCTAssertFalse(containsGroupID, "URL shouldn't contain a URL query item with group id if item outside a group is tapped on.")
    }
    
    func testTrackACClickBuilder_tappingOnItemWithNoGroup_DoesNotSendGroupNameAsQueryParameter() {
        let tracker = CIOAutocompleteClickTrackData(searchTerm: searchTerm, clickedItemName: clickedItemName, sectionName: nil, group: nil)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        
        let containsGroupName = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.contains { (item) -> Bool in
            return item.name == Constants.TrackAutocompleteResultClicked.groupName
        }
        XCTAssertFalse(containsGroupName, "URL shouldn't contain a URL query item with group name if item outside a group is tapped on.")
    }
}

