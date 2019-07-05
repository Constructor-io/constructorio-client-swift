//
//  AutocompleteViewModelSection.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct AutocompleteViewModelSection {
    public let items: [CIOResult]
    public let sectionName: String

    public init(items: [CIOResult], sectionName: String) {
        self.items = items
        self.sectionName = sectionName
    }
}
