//
//  DependencyContainer.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class DependencyContainer {

    public static let sharedInstance = DependencyContainer()

    private init() {}

    public var networkClient: () -> NetworkClient = {
        return URLSessionNetworkClient()
    }

    public var responseParser: () -> AbstractResponseParser = {
        return CIOAutocompleteResponseParser()
    }

    public var sessionManager: () -> SessionManager = {
        return CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: Constants.Query.sessionIncrementTimeoutInSeconds)
    }

    public var clientIDGenerator: () -> IDGenerator = {
        return ClientIDGenerator()
    }
}
