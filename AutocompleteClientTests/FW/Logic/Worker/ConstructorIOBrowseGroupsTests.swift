//
//  ConstructorIOBrowseGroupsTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

class ConstructorIOBrowseGroupsTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: TestConstants.testConfig)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBrowseGroups_CreatesValidRequest() {
        let query = CIOBrowseGroupsQuery()

        let builder = CIOBuilder(expectation: "Calling BrowseGroups should send a valid request.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/groups?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.browseGroups(forQuery: query, completionHandler: { _ in })
        self.wait(for: builder.expectation)
    }

    func testBrowseGroups_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling BrowseGroups with valid parameters should return a non-nil response.")

        let query = CIOBrowseGroupsQuery()
        let dataToReturn = TestResource.load(name: TestResource.Response.searchJSONFilename)

        stub(regex("https://ac.cnstrc.com/browse/groups?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(200, data: dataToReturn))

        self.constructor.browseGroups(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling BrowseGroups with valid parameters should return a non-nil response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseGroups_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling BrowseGroups returns non-nil error if API errors out.")

        let query = CIOBrowseGroupsQuery()

        stub(regex("https://ac.cnstrc.com/browse/groups?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(404))

        self.constructor.browseGroups(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Calling BrowseGroups returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseGroups_AttachesCustomSectionParameter() {
        let customSection = "customSection"
        let query = CIOBrowseGroupsQuery(section: customSection)

        let builder = CIOBuilder(expectation: "Calling BrowseGroups should send a valid request.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/groups?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=\(customSection)&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.browseGroups(forQuery: query, completionHandler: { _ in })
        self.wait(for: builder.expectation)
    }

    func testBrowseGroups_AttachesSpecificGroupId() {
        let query = CIOBrowseGroupsQuery(groupId: "151")

        let builder = CIOBuilder(expectation: "Calling BrowseGroups with a group filter should have a group_id URL query item.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/groups?c=\(kRegexVersion)&filters%5Bgroup_id%5D=151&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.browseGroups(forQuery: query, completionHandler: { _ in })
        self.wait(for: builder.expectation)
    }

    func testBrowseGroups_AttachesMaxDepth() {
        let query = CIOBrowseGroupsQuery(groupsMaxDepth: 5)

        let builder = CIOBuilder(expectation: "Calling BrowseGroups with groups sort option should return a response", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/groups?c=\(kRegexVersion)&fmt_options%5Bgroups_max_depth%5D=5&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.browseGroups(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }

    func testBrowseGroups_UsingBrowseGroupsQueryBuilder_WithValidRequest_ReturnsNonNilResponse() {
        let query = CIOBrowseGroupsQueryBuilder().build()

        let builder = CIOBuilder(expectation: "Calling BrowseGroups with valid parameters should return a non-nil response.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/groups?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.browseGroups(forQuery: query, completionHandler: { _ in })
        self.wait(for: builder.expectation)
    }

    func testBrowseGroups_UsingBrowseGroupsQueryBuilder_AttachesMaxDepth() {
        let query = CIOBrowseGroupsQueryBuilder()
            .setMaxDepth(5)
            .build()

        let builder = CIOBuilder(expectation: "Calling BrowseGroups with valid parameters should return a non-nil response.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/groups?c=\(kRegexVersion)&fmt_options%5Bgroups_max_depth%5D=5&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.browseGroups(forQuery: query, completionHandler: { _ in })
        self.wait(for: builder.expectation)
    }

    func testBrowseGroups_UsingBrowseGroupsQueryBuilder_AttachesCustomSection() {
        let customSection = "customSection"
        let query = CIOBrowseGroupsQueryBuilder()
            .setSection(customSection)
            .build()

        let builder = CIOBuilder(expectation: "Calling BrowseGroups with custom section should return a non-nil response.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/groups?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=\(customSection)&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.browseGroups(forQuery: query, completionHandler: { _ in })
        self.wait(for: builder.expectation)
    }

    func testBrowseGroups_UsingBrowseGroupsQueryBuilder_AttachesSpecificGroupId() {
        let query = CIOBrowseGroupsQueryBuilder()
            .setGroupId("151")
            .build()

        let builder = CIOBuilder(expectation: "Calling BrowseGroups with a group filter should have a group_id URL query item.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/groups?c=\(kRegexVersion)&filters%5Bgroup_id%5D=151&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.browseGroups(forQuery: query, completionHandler: { _ in })
        self.wait(for: builder.expectation)
    }
}
