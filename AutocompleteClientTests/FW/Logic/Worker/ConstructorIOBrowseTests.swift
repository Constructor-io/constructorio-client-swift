//
//  ConstructorIOBrowseTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class ConstructorIOBrowseTests: XCTestCase {

    var constructorIO: ConstructorIO!
    
    override func setUp() {
        super.setUp()
        self.constructorIO = ConstructorIO(config: TestConstants.testConfig)
    }

    func testBrowse_primaryFacetShowsAsPathComponent() {
        let expectation = self.expectation(description: "Encoded key and value should appear in the URL path in the correct order.")

        let key = "just_a_test_key"
        let value = "test value"
        let primaryFacet = FacetParameter(name: key, value: value)

        let urlEncodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let urlEncodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!

        let baseURL = Constants.Query.baseURLString
        let validURLPrefix = "\(baseURL)/browse/\(urlEncodedKey)/\(urlEncodedValue)\(kRegexAnyString)"

        let dataToReturn = TestResource.load(name: TestResource.Response.browseJSONFilename)
        stub(regex(validURLPrefix), http(200, data: dataToReturn))

        self.constructorIO.browse(forQuery: CIOBrowseQuery(primaryFacet: primaryFacet, otherFacets: nil)) { response in
            if response.error == nil {
                expectation.fulfill()
            } else {
                XCTFail("Response for valid request shouldn't be nil")
            }
        }
        self.wait(for: expectation)
    }

    func testBrowse_OtherFacetsAppearAsQueryParameters() {
        let key = "just_a_test_key"
        let value = "test value"
        let primaryFacet = FacetParameter(name: key, value: value)

        let otherFacets = (1...3).map { FacetParameter(name: "key\($0)", value: "value\($0)") }

        let urlEncodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let urlEncodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!

        let builder = CIOBuilder(expectation: "Calling Search should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/\(urlEncodedKey)/\(urlEncodedValue)?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&key1=value1&key2=value2&key3=value3&s=\(kRegexSession)"), builder.create())

        self.constructorIO.browse(forQuery: CIOBrowseQuery(primaryFacet: primaryFacet, otherFacets: otherFacets)) { _ in }
        self.wait(for: builder.expectation)
    }

}
