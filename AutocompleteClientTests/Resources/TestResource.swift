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
        static let numberOfFacetsInSearchResponse = 2
        static let numberOfFacetsOptionsInSearchResponseResult1 = 46
        static let numberOfFacetsOptionsInSearchResponseResult2 = 27
        static let numberOfResultsInSearchResponse = 20
        
        
        static let multipleGroupsJSONFilename = "response_json_multiple_groups"
        static let numberOfGroupsInMultipleSectionsResponse = 7
    }

    static func load(name: String, type: String = "json") -> Data {
        let fileURL = Bundle.testBundle().url(forResource: name, withExtension: type)!
        return try! Data(contentsOf: fileURL)
    }
}
