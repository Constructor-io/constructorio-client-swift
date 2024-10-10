//
//  CIOSessionManagerDelegate.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol CIOSessionManagerDelegate: AnyObject {
    func sessionDidChange(from: Int, to: Int)
}
