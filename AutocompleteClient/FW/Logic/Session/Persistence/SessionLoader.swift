//
//  SessionLoader.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol SessionLoader {

    func loadSession() -> Session?
    func saveSession(_ session: Session)

    func clearSession()
}
