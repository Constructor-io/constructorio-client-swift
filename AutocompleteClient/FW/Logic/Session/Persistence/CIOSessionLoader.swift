//
//  CIOSessionLoader.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOSessionLoader: SessionLoader{
    
    public func loadSession() -> Session?{
        if let data = UserDefaults.standard.object(forKey: Constants.Session.key) as? Data{
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Session
        }else{
            return nil
        }
    }
    
    public func saveSession(_ session: Session){
        let data = NSKeyedArchiver.archivedData(withRootObject: session)
        UserDefaults.standard.set(data, forKey: Constants.Session.key)
    }
    
    public func clearSession() {
        UserDefaults.standard.removeObject(forKey: Constants.Session.key)
    }
    
}
