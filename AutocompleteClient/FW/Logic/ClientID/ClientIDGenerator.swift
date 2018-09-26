//
//  ClientIDGenerator.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

class ClientIDGenerator: IDGenerator{
    func generateID() -> String?{
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
