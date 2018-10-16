//
//  CIOSessionLoader.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 10/16/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation

public struct CIOSessionLoader: SessionLoader{
    
    public func loadSession() -> Session?{
        if let data = UserDefaults.standard.object(forKey: kSession) as? Data{
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Session
        }else{
            return nil
        }
    }
    
    public func saveSession(_ session: Session){
        let data = NSKeyedArchiver.archivedData(withRootObject: session)
        UserDefaults.standard.set(data, forKey: kSession)
    }
    
    public func clearSession() {
        UserDefaults.standard.removeObject(forKey: kSession)
    }
    
}
