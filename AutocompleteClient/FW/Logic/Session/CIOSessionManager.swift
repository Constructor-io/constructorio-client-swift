//
//  CIOSessionManager.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
    
class CIOSessionManager: SessionManager {

    weak var delegate: CIOSessionManagerDelegate?
    
    var sessionID: Int{
        didSet{
            self.delegate?.sessionDidChange(from: oldValue, to: self.sessionID)
        }
    }
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
            self.setSessionHasBeenRequested()
            self.incrementSession()
        }else{
            self.setSessionHasBeenRequested()
        }
        
        return self.sessionID
    }
    
    private func setSessionHasBeenRequested(){
        self.lastSessionRequest = self.dateProvider.provideDate().timeIntervalSince1970
    }
    
    func shouldIncrementSession() -> Bool{
        let diff = (self.dateProvider.provideDate().timeIntervalSince1970 - self.lastSessionRequest)
        return diff >= self.timeout
    }
    
    func incrementSession(){
        self.sessionID += 1
    }
}
