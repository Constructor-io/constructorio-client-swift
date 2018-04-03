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

    var responseParser: () -> AbstractResponseParser = {
        return CIOResponseParser()
    }
    
    var sessionManager: () -> SessionManager = {
        return CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: Constants.Query.sessionIncrementTimeoutInSeconds)
    }

    var userIDGenerator: () -> UserIDGenerator = {
        return DeviceUserIDGenerator()
    }
}
