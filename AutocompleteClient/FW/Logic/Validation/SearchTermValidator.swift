//
//  SearchTermValidator.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class SearchTermValidator {

    public init(){}

    public func validateSearchTerm(_ searchTerm: String?) -> String{
        guard let term = searchTerm, term.count > 0 else {
            return Constants.Track.unknownTerm
        }

        if term.isValidSearchTerm(){
            return term
        }else{
            return Constants.Track.unknownTerm
        }
    }
}
