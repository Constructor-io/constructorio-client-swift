//
//  SessionManager.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol SessionManager: class{
    var delegate: CIOSessionManagerDelegate? { get set }
    
    func getSession() -> Int
}
