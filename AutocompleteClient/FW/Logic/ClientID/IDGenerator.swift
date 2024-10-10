//
//  UserIDGenerator.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol IDGenerator {
    func generateID() -> String?
}
