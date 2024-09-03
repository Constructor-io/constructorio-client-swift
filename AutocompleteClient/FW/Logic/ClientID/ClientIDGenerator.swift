//
//  ClientIDGenerator.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

class ClientIDGenerator: IDGenerator {

    init() {}

    func generateID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
