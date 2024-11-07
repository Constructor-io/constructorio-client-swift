//
//  CIOAutocompleteResult.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//
import Foundation

/**
    Defines an autocomplete item in the list. Since you can search for a term in a group, this class holds
    both the result and the group to search in.
 */

@objc
public class CIOAutocompleteResult: NSObject {
    /**
     Result returned for the query
     */
    public let result: CIOResult

    /**
     Group (or category) the result belongs to
     */
    public let group: CIOGroup?

    /**
     Create a autocomplete result
     
     - Parameters:
        - result: Result info
        - group: Group info
     */
    public init(result: CIOResult, group: CIOGroup? = nil) {
        self.result = result
        self.group = group
    }
}
