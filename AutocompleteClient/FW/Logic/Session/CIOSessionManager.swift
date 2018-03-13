//
//  CIOSessionManager.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 3/9/18.
//  Copyright © 2018 xd. All rights reserved.
//

import UIKit
    
class CIOSessionManager: SessionManager {

    var sessionID: Int
    var lastSessionRequest: TimeInterval
    let timeout: TimeInterval
    let dateProvider: DateProvider
    
    init(dateProvider: DateProvider, timeout: TimeInterval){
        self.sessionID = 1
        self.dateProvider = dateProvider
        self.timeout = timeout
        self.lastSessionRequest = self.dateProvider.provideDate().timeIntervalSince1970
    }

    func getSession() -> Int{
        if self.shouldIncrementSession(){
            self.incrementSession()
        }
        
        self.lastSessionRequest = self.dateProvider.provideDate().timeIntervalSince1970
        
        return self.sessionID
    }
    
    func shouldIncrementSession() -> Bool{
        return (self.dateProvider.provideDate().timeIntervalSince1970 - self.lastSessionRequest) >= self.timeout
    }
    
    func incrementSession(){
        self.sessionID += 1
    }
}
