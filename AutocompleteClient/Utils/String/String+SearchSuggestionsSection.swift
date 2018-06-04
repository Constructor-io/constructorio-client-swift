//
//  String+SearchSuggestionsSection.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 4/10/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation

extension String{
    func isSearchSuggestionString() -> Bool{
        return self.lowercased().replacingOccurrences(of: " ", with: "") == "searchsuggestions"
    }
    
}
