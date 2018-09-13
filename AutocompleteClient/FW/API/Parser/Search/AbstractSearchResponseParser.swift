//
//  AbstractSearchResponseParser.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 9/10/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation

public protocol AbstractSearchResponseParser{
    
    func parse(searchResponseData: Data) throws -> CIOSearchResponse
}
