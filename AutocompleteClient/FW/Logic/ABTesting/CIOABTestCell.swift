//
//  CIOABTestCell.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the AB test cell
 */
public struct CIOABTestCell {
    /**
     The name of the test cell
     */
    let key: String
    
    /**
     The test cell value
     */
    let value: String

    /**
     Create a AB test cell object
     
     - Parameters:
        - key: The name of the test cell
        - value: The test cell value
     
     ```
     ### Usage Example: ###
     let testCell  = CIOABTestCell(key: "search", value: "control")
     ```
     */
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
