//
//  TrackAutocompleteClickRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackAutocompleteSelectRequestBuilderTests: XCTestCase {
    
    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "😃test ink[]"
    fileprivate let originalQuery = "testing#@#??!!asd"
    fileprivate let sectionName = "product"
    
    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedOriginalQuery: String = ""
    fileprivate var encodedSectionName: String = ""
    fileprivate var builder: RequestBuilder!
    
    var dateProvider: DateProvider!
    let fixedDate: Date = Date()
    
    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedOriginalQuery = originalQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedSectionName = sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.builder = RequestBuilder(autocompleteKey: testACKey)
        self.dateProvider = ClosureDateProvider(provideDateClosure: { () -> Date in
            return self.fixedDate
        })
    }
    
    func testTrackAutocompleteSelectBuilder() {
        let tracker = CIOTrackAutocompleteSelectData(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: sectionName)
        builder.build(trackData: tracker)
        builder.dateProvider = self.dateProvider
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        let url = request.url!.absoluteString
        let timeInMiliseconds = Int(self.fixedDate.timeIntervalSince1970 * 1000)

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/select?"), "URL base string should contain the search term.")
        XCTAssertTrue(url.contains("original_query=\(encodedOriginalQuery)"), "URL should contain the original query")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section")
        XCTAssertTrue(url.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key")
        XCTAssertTrue(url.contains("_dt=\(timeInMiliseconds)"), "URL should contain the request date in miliseconds")
    }
    
    func testTrackAutocompleteSelectBuilder_withGroup() {
        let groupName = "groupName1"
        let groupID = "groupID2"
        let groupPath = "path/to/group"
        let group = CIOGroup(displayName: groupName, groupID: groupID, path: groupPath)
        let tracker = CIOTrackAutocompleteSelectData(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: sectionName, group: group)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        
        let containsGroupName = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.contains { (item) -> Bool in
            return item.name == Constants.Track.groupName && item.value! == groupName
        }
        let containsGroupID = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.contains { (item) -> Bool in
            return item.name == Constants.Track.groupID && item.value! == groupID
        }
        XCTAssertTrue(containsGroupName, "URL should contain a URL query item with group name if item in group")
        XCTAssertTrue(containsGroupID, "URL should contain a URL query item with group id if item in group")
    }
    
    func testTrackAutocompleteSelectBuilder_withoutGroup() {
        let tracker = CIOTrackAutocompleteSelectData(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: sectionName, group: nil)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        
        let containsGroupID = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.contains { (item) -> Bool in
            return item.name == Constants.Track.groupID
        }
        let containsGroupName = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.contains { (item) -> Bool in
            return item.name == Constants.Track.groupName
        }
        XCTAssertFalse(containsGroupID, "URL shouldn't contain a URL query item with group id if item outside a group")
        XCTAssertFalse(containsGroupName, "URL shouldn't contain a URL query item with group name if item outside a group")
    }
}

