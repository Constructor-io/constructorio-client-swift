//
//  KeychainService.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Security
import Foundation

class SimpleKeychainService: NSObject {
    
    var service = "ConstructorIOClientIDService"
    var keychainQuery : [CFString: Any]?
    
    @discardableResult
    func save(name: String, value: String) -> OSStatus? {
        let statusAdd: OSStatus?
        
        guard let dataFromString = value.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        self.keychainQuery = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrService : service,
            kSecAttrAccount : name,
            kSecValueData   : dataFromString]
        
        guard let query = self.keychainQuery else {
            return nil
        }
        
        SecItemDelete(query as CFDictionary)
        
        statusAdd = SecItemAdd(query as CFDictionary, nil)
        
        return statusAdd;
    }
    
    @discardableResult
    func load(name: String) -> String? {    
       self.keychainQuery = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrService : service,
            kSecAttrAccount : name,
            kSecReturnData  : kCFBooleanTrue,
            kSecMatchLimit  : kSecMatchLimitOne]
        if self.keychainQuery == nil {
            return nil
        }
        
        guard let query = keychainQuery else { return nil }

        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if (status == errSecSuccess) {
            if let retrievedData = dataTypeRef as? Data,
               let result = String(data: retrievedData, encoding: String.Encoding.utf8) {
                return result
            }
        }
        
        return nil
    }
}
