//
//  TestResource.swift
//  SearchFWTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct TestResource {
    struct Response {
        static let singleSectionJSONFilename = "response_json_single_section"
        static let multipleSectionsJSONFilename = "response_json_multiple_sections"
        static let numberOfSectionsInMultipleSectionsResponse = 2
    }

    static func load(_ name: String, type: String = "json") -> Data {
        let fileURL = Bundle.testBundle().url(forResource: name, withExtension: type)!
        return try! Data(contentsOf: fileURL)
    }
}
