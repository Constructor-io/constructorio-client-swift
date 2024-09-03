//
//  CIOAutocompleteCell.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol CIOAutocompleteCell {
    func setup(result: CIOAutocompleteResult, searchTerm: String, highlighter: CIOHighlighter)
}
