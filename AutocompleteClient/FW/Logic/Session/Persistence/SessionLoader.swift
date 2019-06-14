//
//  SessionLoader.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol SessionLoader {

    func loadSession() -> Session?
    func saveSession(_ session: Session)

    func clearSession()
}
