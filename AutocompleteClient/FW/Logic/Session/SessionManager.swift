//
//  SessionManager.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol SessionManager: AnyObject {
    var delegate: CIOSessionManagerDelegate? { get set }

    func getSessionWithIncrement() -> Int
    func getSessionWithoutIncrement() -> Int

    func setup()
}
