//
//  ConstructorIOConfig.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
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
     The base URL for media tracking requests
     */
    public var baseMediaURL: String?

    /**
     Enables debug mode, in which every tracking event the client sends is logged through `ConstructorIO.logger` and delivered to the listeners added with `addDebugEventListener(_:)`, together with its request and the outcome of that request. Intended for development and QA builds only, do not enable it in production.

     Requests are reported exactly as they were sent: PII found in the URL path and query is obfuscated, but request and response bodies are not redacted.

     The default logger only prints in debug builds of the SDK. Set `ConstructorIO.logger` to your own `CIOLogger` to see the events in other builds.

     ### Usage Example: ###
     ```
     let config = ConstructorIOConfig(apiKey: "YOUR API KEY", debugMode: true)
     let constructorIO = ConstructorIO(config: config)

     // Debug mode can also be switched after the client was created, which applies to the next tracking calls
     constructorIO.config.debugMode = false

     // A logger that also prints the events in builds other than debug builds
     class ConsoleLogger: CIOLogger {
        func log(_ message: String) {
            print(message)
        }
     }
     ConstructorIO.logger = ConsoleLogger()
     ```
     */
    public var debugMode: Bool

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
        - baseMediaURL: The base Media URL to make tracking requests to
        - defaultAnalyticsTags: Additional analytics tags to include with all requests
        - debugMode: Log every tracking event and deliver it to the debug event listeners. For development and QA builds only

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
        baseURL: "https://ac.cnstrc.com"
     )
     ```
     */
    public init(apiKey: String, resultCount: AutocompleteResultCount? = nil, defaultItemSectionName: String? = nil, testCells: [CIOABTestCell]? = nil, segments: [String]? = nil, baseURL: String? = nil, baseQuizURL: String? = nil, baseMediaURL: String? = nil, defaultAnalyticsTags: [String: String]? = nil, debugMode: Bool = false) {
        self.apiKey = apiKey
        self.resultCount = resultCount
        self.defaultItemSectionName = defaultItemSectionName
        self.testCells = testCells
        self.segments = segments
        self.baseURL = baseURL
        self.baseQuizURL = baseQuizURL
        self.baseMediaURL = baseMediaURL
        self.defaultAnalyticsTags = defaultAnalyticsTags
        self.debugMode = debugMode
    }

}
