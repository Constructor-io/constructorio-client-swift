//
//  AutocompleteViewModelSection.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct AutocompleteViewModelSection {
    public let items: [CIOAutocompleteResult]
    public let sectionName: String

    public init(items: [CIOAutocompleteResult], sectionName: String) {
        self.items = items
        self.sectionName = sectionName
    }
}
