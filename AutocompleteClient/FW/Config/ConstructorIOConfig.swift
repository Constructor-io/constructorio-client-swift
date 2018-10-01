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
    public var resultCount: AutocompleteResultCount?
    
    public init(apiKey: String, resultCount: AutocompleteResultCount? = nil){
        self.apiKey = apiKey
        self.resultCount = resultCount
    }
    
}
