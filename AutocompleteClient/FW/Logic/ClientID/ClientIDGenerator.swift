//
//  ClientIDGenerator.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

public class ClientIDGenerator: IDGenerator {

    public init() {}

    public func generateID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
