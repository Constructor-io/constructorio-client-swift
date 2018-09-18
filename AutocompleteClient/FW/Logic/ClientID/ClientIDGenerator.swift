//
//  ClientIDGenerator.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

class ClientIDGenerator: UserIDGenerator{

    let keychainService = SimpleKeychainService()
    
    func generateClientID() -> String?{
        if let id = keychainService.load(name: Constants.ClientID.key){
            return id
        }else{
            if let uuid = UIDevice.current.identifierForVendor?.uuidString{
                self.keychainService.save(name: Constants.ClientID.key, value: uuid)
                return uuid
            }else{
                return nil
            }
        }
    }
}
