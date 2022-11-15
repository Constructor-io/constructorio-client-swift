//
//  CIOQuizResultsResponse.swift
//  ConstructorAutocomplete
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the quiz result response from the server.
 */
public struct CIOQuizResultsResponse {
    /**
     Quiz result
     */
    public let result: CIOQuizResult
    
    /**
     Version Id of the quiz result 
     */
    public let versionId: String
}
