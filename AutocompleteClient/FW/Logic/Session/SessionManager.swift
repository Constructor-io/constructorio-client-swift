//
//  SessionManager.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol SessionManager: AnyObject {
    var delegate: CIOSessionManagerDelegate? { get set }

    func getSessionWithIncrement() -> Int
    func getSessionWithoutIncrement() -> Int

    func setSessionID(id: Int)

    func setup()
}
