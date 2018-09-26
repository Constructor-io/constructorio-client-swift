//
//  Constants.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct AutocompleteConfig {

    public let autocompleteKey: String
    public var resultCount: AutocompleteResultCount?
    
    public init(autocompleteKey: String, resultCount: AutocompleteResultCount? = nil){
        self.autocompleteKey = autocompleteKey
        self.resultCount = resultCount
    }
    
}
