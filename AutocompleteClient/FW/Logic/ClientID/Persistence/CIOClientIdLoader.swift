//
//  CIOClientIdLoader.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct CIOClientIdLoader: ClientIdLoader {

    init() {}

    func loadClientId() -> String? {
        if let clientId = UserDefaults.standard.object(forKey: Constants.Session.clientId) as? String {
            return clientId
        } else if let clientId  = DependencyContainer.sharedInstance.clientIDGenerator().generateID() {
            saveClientId(clientId)
            return clientId
        } else  {
            let uuid = NSUUID().uuidString
            saveClientId(uuid)
            return uuid
        }
    }

    func saveClientId(_ clientId: String) {
        UserDefaults.standard.set(clientId, forKey: Constants.Session.clientId)
    }

    func clearClientId() {
        UserDefaults.standard.removeObject(forKey: Constants.Session.clientId)
    }

}
