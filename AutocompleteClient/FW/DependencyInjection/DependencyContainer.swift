//
//  DependencyContainer.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

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
    
    var sessionManager: () -> SessionManager = {
        return CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: Constants.Query.sessionIncrementTimeoutInSeconds)
    }

    var clientIDGenerator: () -> IDGenerator = {
        return ClientIDGenerator()
    }
}
