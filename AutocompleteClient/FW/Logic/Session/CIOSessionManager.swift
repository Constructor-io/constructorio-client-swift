//
//  CIOSessionManager.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
    
public class CIOSessionManager: SessionManager {

    public weak var delegate: CIOSessionManagerDelegate?
    
    public var sessionID: Int{
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterForeground(_:)), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    @objc
    public func applicationDidEnterForeground(_ notification: Notification){
        self.reloadSession()
    }
    
    public func getSession() -> Int{
        self.reloadSession()
        
        return self.sessionID
    }
    
    func reloadSession(){
        if self.shouldIncrementSession(){
            self.incrementSession()
        }
        
        self.setSessionHasBeenRequested()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
