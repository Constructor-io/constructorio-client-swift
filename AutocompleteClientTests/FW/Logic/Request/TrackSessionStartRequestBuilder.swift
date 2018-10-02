//
//  TrackSessionStartRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackSessionStartRequestBuilderTests: XCTestCase {
    
    fileprivate let testACKey = "asdf1213123"
    fileprivate let session = 90

    fileprivate var builder: RequestBuilder!
    
    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey)
    }
    
    func testTrackSessionStartBuilder() {
        let tracker = CIOTrackSessionStartData(session: session)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/behavior?"))
        XCTAssertTrue(url.contains("action=session_start"), "URL should contain the session start action")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
    }
}
