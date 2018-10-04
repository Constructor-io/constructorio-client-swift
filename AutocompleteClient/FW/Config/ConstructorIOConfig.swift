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
    public var defaultSectionName: String?
    public var resultCount: AutocompleteResultCount?
    
    public init(apiKey: String, resultCount: AutocompleteResultCount? = nil, defaultSectionName: String? = nil, testCells: [CIOABTestCell]? = nil){
        self.apiKey = apiKey
        self.resultCount = resultCount
        self.defaultSectionName = defaultSectionName
        self.testCells = testCells
    }
    
}
