//
//  String+Regex.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension String{
    func regex(_ pattern: String) -> Bool{
        do {
            let matchRange = try NSRegularExpression(pattern: pattern, options: []).rangeOfFirstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))
            return matchRange.location == 0 && matchRange.length == self.count
        } catch {
            return false
        }
    }
}

extension String{
    func isValidSearchTerm() -> Bool{
        return self.regex(Constants.Track.searchTermRegex)
    }
}
