//
//  CIOQuizResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the search data response from the server.
 */
public struct CIOQuizzesResponse {
    /**
     List of facets returned for the result set
     */
    public let nextQuestion: CIOQuestionData
    
    /**
     Version Id of the result question
     */
    public let versionId: String?

    /**
     Is the question last
     */
    public let isLastQuestion: Bool?
}
