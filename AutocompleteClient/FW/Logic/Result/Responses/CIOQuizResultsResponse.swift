//
//  CIOQuizResultsResponse.swift
//  ConstructorAutocomplete
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
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
     Unique quiz_version_id for the quiz.
     The quiz version id will be returned with the first request and it should be passed with subsequent requests.
     More information can be found: https://docs.constructor.io/rest_api/quiz/using_quizzes/#quiz-versioning
     */
    public let quizVersionID: String

    /**
     Unique quiz_session_id for the quiz.
     The quiz session id will be returned with the first request and it should be passed with subsequent requests.
     More information can be found: https://docs.constructor.io/rest_api/quiz/using_quizzes/#quiz-sessions
     */
    public let quizSessionID: String

    /**
     Id of the quiz
     */
    public let quizID: String
    
    /**
     Request object used to retrieve the Quizzes Response
     */
    public var request: JSONObject
}
