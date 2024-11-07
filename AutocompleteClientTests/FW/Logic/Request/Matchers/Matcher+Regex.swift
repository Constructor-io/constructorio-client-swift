//
//  Matcher+Regex.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import XCTest

// Returns a MockingJay Matcher if the URL string matches a regex
public func regex(_ pattern: String, prepare: Bool = true) -> Matcher {
    return { request in
        let absoluteURLString = request.url!.absoluteString

        let preparedPattern = prepare ? prepareRegexPattern(pattern) : pattern
        do {
            let matchRange = try NSRegularExpression(pattern: preparedPattern, options: []).rangeOfFirstMatch(in: absoluteURLString, options: [], range: NSRange(location: 0, length: absoluteURLString.count))
            return matchRange.location == 0 && matchRange.length == absoluteURLString.count
        } catch {
            return false
        }
    }
}

// escape occurences of '?' and '/'
private func prepareRegexPattern(_ pattern: String) -> String {
    return pattern.replacingOccurrences(of: "/", with: "\\/")
                  .replacingOccurrences(of: "?", with: "\\?")
}
