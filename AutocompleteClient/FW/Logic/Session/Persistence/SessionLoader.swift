//
//  SessionLoader.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol SessionLoader{
    
    func loadSession() -> Session?
    func saveSession(_ session: Session)
    
    func clearSession()
}
