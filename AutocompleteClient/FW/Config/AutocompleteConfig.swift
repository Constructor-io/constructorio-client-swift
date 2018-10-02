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
<<<<<<< HEAD
    
    public init(autocompleteKey: String, resultCount: AutocompleteResultCount? = nil){
        self.autocompleteKey = autocompleteKey
        self.resultCount = resultCount
=======
    public var clientID: String?
    public var testCells: [CIOABTestCell]?
    
    public init(autocompleteKey: String, resultCount: AutocompleteResultCount? = nil, clientID: String? = nil, testCells: [CIOABTestCell]? = nil){
        self.autocompleteKey = autocompleteKey
        self.resultCount = resultCount
        self.clientID = clientID
        self.testCells = testCells
>>>>>>> 9629388ab390297b07e997cc8e4a18eb93aba86b
    }
    
}
