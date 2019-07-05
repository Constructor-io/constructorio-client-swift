//
//  ClientIDGenerator.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
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
