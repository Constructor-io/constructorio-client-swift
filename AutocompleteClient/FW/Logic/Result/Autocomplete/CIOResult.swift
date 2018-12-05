//
//  CIOResult.swift
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
public class CIOResult: NSObject {
    public let autocompleteResult: CIOAutocompleteResult
    public let group: CIOGroup?

    init(autocompleteResult: CIOAutocompleteResult, group: CIOGroup? = nil) {
        self.autocompleteResult = autocompleteResult
        self.group = group
    }
}
