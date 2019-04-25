//
//  TestResource.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct TestResource {
    struct Response {
        static let singleResultJSONFilename = "response_json_single_result"
        static let singleSectionJSONFilename = "response_json_single_section"
        static let multipleSectionsJSONFilename = "response_json_multiple_sections"
        static let numberOfSectionsInMultipleSectionsResponse = 2

        static let searchJSONFilename = "response_search_json"
        static let searchJSONRedirectFile = "response_search_redirect"
        static let numberOfFacetsInSearchResponse = 2
        static let numberOfFacetsOptionsInSearchResponseResult1 = 43
        static let numberOfFacetsOptionsInSearchResponseResult2 = 26
        static let numberOfResultsInSearchResponse = 24

        static let multipleGroupsJSONFilename = "response_json_multiple_groups"
        static let numberOfGroupsInMultipleSectionsResponse = 7
    }

    static func load(name: String, type: String = "json") -> Data {
        let fileURL = Bundle.testBundle().url(forResource: name, withExtension: type)!
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            return Data(count: 0)
        }
    }
}
