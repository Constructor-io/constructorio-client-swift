//
//  UserIDGenerator.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol IDGenerator {
    func generateID() -> String?
}
