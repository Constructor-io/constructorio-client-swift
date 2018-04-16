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
    
    func testTrackACClickBuilder_sectionNameSpecified_selectType() {
        let tracker = CIOAutocompleteClickTrackData(searchTerm: searchTerm, clickedItemName: clickedItemName, sectionName: sectionName)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedClickedItemName)/select?autocomplete_key=\(testACKey)&original_query=\(encodedSearchTerm)&autocomplete_section=\(encodedSectionName)&tr=click&_dt=\(requestDate)&c=\(Constants.versionString())"))
    }
    
    func testTrackACClickBuilder_sectionNameUnspecified_searchType() {
        let tracker = CIOAutocompleteClickTrackData(searchTerm: searchTerm, clickedItemName: clickedItemName)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedClickedItemName)/search?autocomplete_key=\(testACKey)&original_query=\(encodedSearchTerm)&tr=click&_dt=\(requestDate)&c=\(Constants.versionString())"))
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

