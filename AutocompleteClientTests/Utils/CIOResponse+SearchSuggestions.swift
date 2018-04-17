//
//  CIOResponse+SearchSuggestions.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
@testable import ConstructorAutocomplete

extension CIOResponse{
    func getSearchSuggestions() -> [CIOResult]?{
        return self.sections["Search Suggestions"]
    }
}