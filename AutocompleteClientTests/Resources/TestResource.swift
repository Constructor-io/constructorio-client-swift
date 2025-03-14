//
//  TestResource.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import XCTest

struct TestResource {
    struct Response {
        static let singleResultJSONFilename = "response_json_single_result"
        static let singleSectionJSONFilename = "response_json_single_section"
        static let multipleSectionsJSONFilename = "response_json_multiple_sections"
        static let numberOfSectionsInMultipleSectionsResponse = 2

        static let searchJSONFilename = "response_search_json"
        static let browseJSONFilename = "response_browse_json"
        static let browseFacetsJSONFilename = "response_browse_facets_json"
        static let browseFacetOptionsJSONFilename = "response_browse_facet_options_json"
        static let searchJSONRedirectFile = "response_search_redirect"
        static let numberOfFacetsInSearchResponse = 2
        static let numberOfFacetsOptionsInSearchResponseResult1 = 43
        static let numberOfFacetsOptionsInSearchResponseResult2 = 26
        static let numberOfResultsInSearchResponse = 24

        static let multipleGroupsJSONFilename = "response_json_multiple_groups"
        static let numberOfGroupsInMultipleSectionsResponse = 7

        static let multipleVariationsJSONFilename = "response_search_json_variations"
        static let multipleVariationsCount = 3

        static let multipleInvalidVariationsJSONFilename = "response_search_json_invalid_variations"
        static let multipleInvalidVariationsValidVariationCount = 1

        static let multipleVariationsWithCustomDataJSONFilename = "response_search_json_variation_custom_data"

        static let recommendationsJSONFilename = "response_recommendations"
        static let quizQuestionJSONFilename = "response_quiz_next_question"
        static let quizResultsJSONFilename = "response_quiz_results"
        static let numberOfResultsInRecommendationsResponse = 10

        static let searchJSONRefinedContentFilename = "response_search_json_refined_content"
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
