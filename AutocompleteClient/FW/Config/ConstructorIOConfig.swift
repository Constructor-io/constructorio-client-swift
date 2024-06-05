//
//  ConstructorIOConfig.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the configuration options needed to make requests
 */
public struct ConstructorIOConfig {
    /**
     The API key
     */
    public let apiKey: String

    /**
     The default number of results to request for
     */
    public var resultCount: AutocompleteResultCount?

    /**
     The default section to request items from
     */
    public var defaultItemSectionName: String?

    /**
     List of test cell information to associate with requests
     */
    public var testCells: [CIOABTestCell]?
    
    /**
     Additional analytics tags to pass. Will be merged with analytics tags passed on the request level
     */
    public var defaultAnalyticsTags: [String: String]?

    /**
     List of segments to associate with requests
     */
    public var segments: [String]?

    /**
     The base URL to make requests to
     */
    public var baseURL: String?

    /**
     The base URL to make requests to
     */
    public var baseQuizURL: String?

    /**
     Create a configuration object
     
     - Parameters:
        - apiKey: The API Key
        - resultCount: The default number of results to request for
        - defaultItemSectionName: The default section to request items from
        - testCells: List of test cell information to associate with requests
        - segments: List of segments to associate with requets
        - baseURL: The base URL to make requests to
        - baseQuizURL: The base Quiz URL to make requests to

     ### Usage Example: ###
     ```
     let config = ConstructorIOConfig(
        apiKey: "YOUR API KEY",
        resultCount: AutocompleteResultCount(numResultsForSection: ["Search Suggestions": 3, "Products": 0]),
        defaultItemSectionName: "Products",
        segments: ["Android", "US"],
        testCells: [
            CIOABTestCell(key: "search", value: "constructor"),
            CIOABTestCell(key: "autosuggest", value: "control")
        ],
        baseURL: "ac.cnstrc.com"
     )
     ```
     */
    public init(apiKey: String, resultCount: AutocompleteResultCount? = nil, defaultItemSectionName: String? = nil, testCells: [CIOABTestCell]? = nil, segments: [String]? = nil, baseURL: String? = nil, baseQuizURL: String? = nil, defaultAnalyticsTags: [String: String]? = nil) {
        self.apiKey = apiKey
        self.resultCount = resultCount
        self.defaultItemSectionName = defaultItemSectionName
        self.testCells = testCells
        self.segments = segments
        self.baseURL = baseURL
        self.baseQuizURL = baseQuizURL
        self.defaultAnalyticsTags = defaultAnalyticsTags
    }

}
