//
//  ConstructorIOConfig.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct ConstructorIOConfig {

    public let apiKey: String
    public var defaultItemSectionName: String?
    public var resultCount: AutocompleteResultCount?
    public var testCells: [CIOABTestCell]?
    public var segments: [String]?
    public var baseURL: String?

    public init(apiKey: String, resultCount: AutocompleteResultCount? = nil, defaultItemSectionName: String? = nil, testCells: [CIOABTestCell]? = nil, segments: [String]? = nil, baseURL: String? = nil) {
        self.apiKey = apiKey
        self.resultCount = resultCount
        self.defaultItemSectionName = defaultItemSectionName
        self.testCells = testCells
        self.segments = segments
        self.baseURL = baseURL
    }

}
