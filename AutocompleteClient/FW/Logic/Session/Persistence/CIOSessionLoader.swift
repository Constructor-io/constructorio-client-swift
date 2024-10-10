//
//  CIOSessionLoader.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct CIOSessionLoader: SessionLoader {

    init() {}

    func loadSession() -> Session? {
        if let data = UserDefaults.standard.object(forKey: Constants.Session.key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Session
        } else {
            return nil
        }
    }

    func saveSession(_ session: Session) {
        let data = NSKeyedArchiver.archivedData(withRootObject: session)
        UserDefaults.standard.set(data, forKey: Constants.Session.key)
    }

    func clearSession() {
        UserDefaults.standard.removeObject(forKey: Constants.Session.key)
    }

}
