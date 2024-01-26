//
//  ClientIdLoader.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol ClientIdLoader {

    func loadClientId() -> String?
    func saveClientId(_ clientId: String)

    func clearClientId()
}
