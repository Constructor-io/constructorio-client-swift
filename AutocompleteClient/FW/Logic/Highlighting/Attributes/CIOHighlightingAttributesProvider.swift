//
//  CIOHighlightingAttributesProvider.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Provides higlighting attributes.
 */
public protocol CIOHighlightingAttributesProvider {
    /**
     Method called by the CIOHiglighter to get highlighting attributes for parts of the string that aren't matched in the search term.

     - returns: NSAttributeString attributes for unmatched parts of the search term.
     */
    func defaultSubstringAttributes() -> [NSAttributedString.Key: Any]

    /**
     Method called by the CIOHiglighter to get highlighting attributes for parts of the string that are matched in the search term.

     - returns: NSAttributeString attributes for matched parts of the search term.
     */
    func highlightedSubstringAttributes() -> [NSAttributedString.Key: Any]
}
