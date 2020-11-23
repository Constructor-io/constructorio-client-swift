//
//  CIOAutocompleteResult.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/** Defines an autocomplete item in the list. Since you can search for a term in a group, this class holds
    both the result and the group to search in.
 */

@objc
public class CIOAutocompleteResult: NSObject {
    public let result: CIOResult
    public let group: CIOGroup?

    public init(autocompleteResult: CIOResult, group: CIOGroup? = nil) {
        self.result = autocompleteResult
        self.group = group
    }
}
