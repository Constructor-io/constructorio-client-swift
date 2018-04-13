//
//  CIOResponse+SearchSuggestions.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 4/4/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation
@testable import ConstructorAutocomplete

extension CIOResponse{
    func getSearchSuggestions() -> [CIOResult]?{
        return self.sections["Search Suggestions"]
    }
}
