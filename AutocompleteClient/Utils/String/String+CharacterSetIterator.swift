//
//  String+CharacterSetIterator.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension String {

    func makeIterator(characterSet: CharacterSet) -> StringCharacterSetIterator {
        return StringCharacterSetIterator(string: self, characterSet: characterSet)
    }

}

extension NSString {

    func rangeOfCharacters(from characterSet: CharacterSet) -> NSRange {
        var firstRange = self.rangeOfCharacter(from: characterSet)
        if firstRange.location == NSNotFound {
            return firstRange
        }

        // If its found, try to find more after it
        var currentIndex = firstRange.location + 1
        while currentIndex < self.length {
            // Check if the current index substring is also a rangeOfChar
            let substring = self.substring(with: NSRange(location: currentIndex, length: 1))
            if substring.rangeOfCharacter(from: characterSet) == nil {
                break
            }
            currentIndex += 1
            firstRange.length += 1
        }

        return firstRange
    }
}

extension NSRange: Equatable{}

public func ==(lhs: NSRange, rhs: NSRange) -> Bool{
    return lhs.location == rhs.location && lhs.length == rhs.length
}

struct StringCharacterSetIterator {

    private var string: NSMutableString
    private let characterSet: CharacterSet
    private var nextPassingRange: NSRange?

    init(string: String, characterSet: CharacterSet) {
        self.string = NSMutableString(string: string)
        self.characterSet = characterSet
    }

    mutating func next() -> (Bool, String)? {
        if string.length == 0 { return nil }

        // If there are previous results, use it
        if let nextPassingRange = nextPassingRange {
            let result = string.substring(with: nextPassingRange)
            string.deleteCharacters(in: nextPassingRange)
            self.nextPassingRange = nil
            return (true, result)
        }

        // No previous results, find now
        let passingRange = string.rangeOfCharacters(from: characterSet)
        // CHeck if there is even a matching range
        if passingRange.length == 0 {
            // The remaining range of chars is not matching
            let result = String(string)
            string = NSMutableString()
            return (false, result)
        }

        // There is a matching range within the remaining
        // Check if it begins from the first char
        if passingRange.location == 0 {
            // Passing range begins from first char
            let result = string.substring(with: passingRange)
            string.deleteCharacters(in: passingRange)
            return (true, result)
        }

        // There is a non-passing range at the start
        let range = NSRange(location: 0, length: passingRange.length)
        nextPassingRange = range
        let result = string.substring(to: passingRange.location)
        string.deleteCharacters(in: NSRange(location: 0, length: passingRange.location))
        return (false, result)
    }

}
