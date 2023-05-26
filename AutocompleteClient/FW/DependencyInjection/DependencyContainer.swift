//
//  DependencyContainer.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class DependencyContainer {

    static let sharedInstance = DependencyContainer()

    private init() {}

    var networkClient: () -> NetworkClient = {
        return URLSessionNetworkClient()
    }

    var autocompleteResponseParser: () -> AbstractAutocompleteResponseParser = {
        return CIOAutocompleteResponseParser()
    }

    var searchResponseParser: () -> AbstractSearchResponseParser = {
        return SearchResponseParser()
    }

    var browseResponseParser: () -> AbstractBrowseResponseParser = {
        return BrowseResponseParser()
    }
    
    var browseFacetsResponseParser: () -> AbstractBrowseFacetsResponseParser = {
        return BrowseFacetsResponseParser()
    }

    var browseFacetOptionsResponseParser: () -> AbstractBrowseFacetOptionsResponseParser = {
        return BrowseFacetOptionsResponseParser()
    }
    
    var recommendationsResponseParser: () -> AbstractRecommendationsResponseParser = {
        return RecommendationsResponseParser()
    }
    
    var quizQuestionResponseParser: () -> AbstractQuizQuestionResponseParser = {
        return QuizQuestionResponseParser()
    }
    
    var quizResultsResponseParser: () -> AbstractQuizResultsResponseParser = {
        return QuizResultsResponseParser()
    }

    var sessionManager: () -> SessionManager = {
        return CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: Constants.Query.sessionIncrementTimeoutInSeconds)
    }

    var clientIDGenerator: () -> IDGenerator = {
        return ClientIDGenerator()
    }
}
