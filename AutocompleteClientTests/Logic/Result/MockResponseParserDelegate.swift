//
//  MockResponseParserDelegate.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 3/5/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation
@testable import ConstructorAutocomplete

class MockResponseParserDelegate: NSObject, ResponseParserDelegate {

    var shouldParseResultInGroup: (_ result: CIOAutocompleteResult, _ group: CIOGroup?) -> Bool = { _,_  in return true }
    var shouldParseResultsInSection: (_ name: String) -> Bool = { _ in return true }
    
    func shouldParseResult(result: CIOAutocompleteResult, inGroup group: CIOGroup?) -> Bool{
        return self.shouldParseResultInGroup(result, group)
    }
    
    func shouldParseResults(inSectionWithName name: String) -> Bool{
        return self.shouldParseResultsInSection(name)
    }
}
