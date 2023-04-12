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
     List of facets returned for the result set
     */
    public let facets: [CIOFilterFacet]

    /**
     List of groups (categories) returned for the result set
     */
    public let groups: [CIOFilterGroup]

    /**
     List of results returned for the browse query
     */
    public let results: [CIOResult]

    /**
     List of sorting options
     */
    public let sortOptions: [CIOSortOption]
    
    /**
     Total number of results for the result
     */
    public let totalNumResults: Int
    
    /**
     Sources of the result set
     */
    public let resultSources: CIOResultSources?
    
    /**
     Result ID of the result set returned
     */
    public let resultID: String
    
    /**
     Version Id of the quiz result 
     */
    public let versionId: String
    
    /**
     Session Id of the quiz result
     */
    public let sessionId: String
    
    /**
     Id of the quiz
     */
    public let quizId: String
}
