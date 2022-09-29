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
     Next question in the quiz
     */
    public let nextQuestion: CIOQuestionData?
    
    /**
     Final question in the quiz
     */
    public let result: CIOQuizzesFinalizeData?
    
    /**
     Version Id of the result question
     */
    public let versionId: String?

    /**
     Is the question last
     */
    public let isLastQuestion: Bool?
}
