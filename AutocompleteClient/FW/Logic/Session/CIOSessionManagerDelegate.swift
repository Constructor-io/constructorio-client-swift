//
//  CIOSessionManagerDelegate.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol CIOSessionManagerDelegate: class{
    func sessionDidChange(from: Int, to: Int)
}
