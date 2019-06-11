//
//  CIOHighlighter.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

/**
 Class responsible for result highlighting. It uses attributesProvider to get the string styling attributes.
 */
public class CIOHighlighter {

    /**
     Provides higlighting attributes.
     */
    public var attributesProvider: CIOHighlightingAttributesProvider

    public init(attributesProvider: CIOHighlightingAttributesProvider) {
        self.attributesProvider = attributesProvider
    }

    /**
     Highlights the parts of the string matched in the search term.

     - parameter searchTerm: Search term used to query for results.
     - parameter itemTitle: Result item title which contains the search term, or parts of it.

     - returns: NSAttributeString with highlighted parts of the string. Styling is provided by the attributesProvider.
     */
    public func highlight(searchTerm: String, itemTitle: String) -> NSAttributedString {
        // Tokenize search term
        let searchTokens = searchTerm.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let finalString = NSMutableAttributedString()

        // Match on tokenized results
        var iterator = itemTitle.makeIterator(characterSet: .alphanumerics)
        while let (matches, result) = iterator.next() {
            guard matches else {
                // Not-matched, add specified font for default
                finalString.append(NSAttributedString.build(string: result, attributes: self.attributesProvider.defaultSubstringAttributes()))
                continue
            }
            
            // An alphanumeric match
            // Check prefix match
            let (prefix, suffix) = getBestPrefixBetween(prefixers: searchTokens, prefixee: result)

            // Add specified font for highlighted
            finalString.append(NSAttributedString.build(string: prefix, attributes: self.attributesProvider.highlightedSubstringAttributes()))

            // Add specified font for non-highlighted
            finalString.append(NSAttributedString.build(string: suffix, attributes: self.attributesProvider.defaultSubstringAttributes()))
        }
        return finalString
    }

    // Identify the best possible prefix match by any of the prefixers onto the given prefixee.
    private func getBestPrefixBetween(prefixers: [String], prefixee: String) -> (String, String) {
        var bestMatch = 0
        for prefixer in prefixers {
            if prefixer.count > prefixee.count {
                continue
            }
            guard prefixee.lowercased().hasPrefix(prefixer.lowercased()), prefixer.count > bestMatch else { continue }
            bestMatch = prefixer.count
        }
        let index = prefixee.index(prefixee.startIndex, offsetBy: bestMatch)

        return (String(prefixee[..<index]), String(prefixee[index...]))
    }
}
