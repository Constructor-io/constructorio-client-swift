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
    
    var dateProvider: DateProvider!
    let fixedDate: Date = Date()
    
    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedClickedItemName = clickedItemName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedSectionName = sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        self.dateProvider = ClosureDateProvider(provideDateClosure: { () -> Date in
            return self.fixedDate
        })
    }
    
    private func initializeClickTrackDataRequestWithNoSectionName() -> URLRequest{
        let tracker = CIOAutocompleteClickTrackData(searchTerm: searchTerm, clickedItemName: clickedItemName)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        builder.dateProvider = self.dateProvider
        let request = builder.getRequest()
        return request
    }
    
    private func initializeClickTrackDataRequestWithSectionName() -> URLRequest{
        let tracker = CIOAutocompleteClickTrackData(searchTerm: searchTerm, clickedItemName: clickedItemName, sectionName: sectionName)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        builder.dateProvider = self.dateProvider
        let request = builder.getRequest()
        return request
    }
    
    // with section name
    
    func testTrackACClickBuilder_sectionNameSpecified_selectType() {
        let request = self.initializeClickTrackDataRequestWithSectionName()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedClickedItemName)/select?"), "URL base string should contain the encoded clicked item name.")
        XCTAssertTrue(request.url!.absoluteString.contains("original_query=\(encodedSearchTerm)"), "URL should contain the original query")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(request.url!.absoluteString.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key")
    }
    
    // No section name
    
    func testTrackACClickBuilder_withNoSectionName_hasNoSectionName() {
        let request = self.initializeClickTrackDataRequestWithNoSectionName()
                XCTAssertTrue(!request.url!.absoluteString.contains("\(Constants.TrackAutocomplete.autocompleteSection)="), "URL shouldn't contain autocomplete section if the section name is not passed.")
    }
    
    func testTrackACClickBuilder_withNoSectionName_selectType() {
        let request = self.initializeClickTrackDataRequestWithNoSectionName()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedClickedItemName)/search?"), "URL base string should contain the encoded clicked item name.")
        XCTAssertTrue(request.url!.absoluteString.contains("original_query=\(encodedSearchTerm)"), "URL should contain the original query")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(request.url!.absoluteString.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key")
        XCTAssertTrue(request.url!.absoluteString.contains("tr=click"), "URL should contain the track type")
    }
    
    func testTrackACClickBuilder_containsDateInMiliseconds(){
        let request = self.initializeClickTrackDataRequestWithNoSectionName()
        let timeInMiliseconds = Int(self.fixedDate.timeIntervalSince1970 * 1000)
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(timeInMiliseconds)"), "URL should contain the request date in miliseconds")
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

