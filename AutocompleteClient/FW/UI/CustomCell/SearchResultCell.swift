//
//  SearchResultCell.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol CIOAutocompleteCell {
    func setup(title: String, searchTerm: String, highlighter: CIOHighlighter)
}
