//
//  MockResponseParserDelegate.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
@testable import ConstructorAutocomplete

class MockResponseParserDelegate: NSObject, ResponseParserDelegate {

    var shouldParseResultInGroup: ((_ result: CIOResult, _ group: CIOGroup?) -> Bool)? = { _, _  in return true }

    func shouldParseResult(result: CIOResult, inGroup group: CIOGroup?) -> Bool? {
        return self.shouldParseResultInGroup?(result, group)
    }

    func maximumGroupsShownPerResult(result: CIOResult, at index: Int) -> Int {
        return 1
    }

}
