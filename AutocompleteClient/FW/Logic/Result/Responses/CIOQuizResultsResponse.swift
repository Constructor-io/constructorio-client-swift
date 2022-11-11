//
//  CIOQuizResultsResponse.swift
//  ConstructorAutocomplete
//
//  Created by Islam Mouatafa on 11/9/22.
//  Copyright © 2022 xd. All rights reserved.
//

import Foundation

/**
 Struct representing the quiz result data response from the server.
 */
public struct CIOQuizResultsResponse {
    /**
     quiz result
     */
    public let result: CIOQuizResultsData
    
    /**
     Version Id of the result question
     */
    public let versionId: String
}
