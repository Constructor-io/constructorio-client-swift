//
//  CIOHighlightingAttributesProvider.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
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
    func defaultSubstringAttributes() -> [String: Any]

    /**
     Method called by the CIOHiglighter to get highlighting attributes for parts of the string that are matched in the search term.

     - returns: NSAttributeString attributes for matched parts of the search term.
     */
    func highlightedSubstringAttributes() -> [String: Any]
}
