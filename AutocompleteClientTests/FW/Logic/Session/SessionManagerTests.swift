//
//  SessionManagerTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class SessionManagerTests: XCTestCase {
    
    func testSessionManager_HasCorrentInitialSession(){
        let manager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: 30)
        XCTAssertEqual(manager.getSession(), 1, "Initial session should be 1.")
    }
    
    func testSessionManager_DoesNotIncrementAutomatically(){
        let manager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: 30)
        let first = manager.getSession()
        let second = manager.getSession()
        XCTAssertEqual(first, second, "Calling getSession multiple times before timing out should not increment the session.")
    }
    
    func testSessionManager_DoesNotIncrementsSession_IfTimeoutIsNotReached(){
        let initialDate = Date()
        let initialTimeout: TimeInterval = 30
        
        let dateProvider = ClosureDateProvider { () -> Date in
            return initialDate
        }
        
        let manager = CIOSessionManager(dateProvider: dateProvider, timeout: initialTimeout)
        
        let initialSession = manager.getSession()
        
        dateProvider.provideDateClosure = {
            return initialDate.addingTimeInterval(initialTimeout-1)
        }
        
        let nextSession = manager.getSession()
        
        XCTAssertEqual(nextSession, initialSession, "Calling getSession multiple times before timing out should not increment the session.")
    }
    
    func testSessionManager_IncrementsSession_IfTimeoutIsReached(){
        let initialDate = Date()
        let initialTimeout: TimeInterval = 30
        
        let dateProvider = ClosureDateProvider { () -> Date in
            return initialDate
        }
        
        let manager = CIOSessionManager(dateProvider: dateProvider, timeout: initialTimeout)
        
        let initialSession = manager.getSession()
        
        dateProvider.provideDateClosure = {
            return initialDate.addingTimeInterval(initialTimeout)
        }
        
        let nextSession = manager.getSession()
        
        XCTAssertEqual(nextSession, initialSession+1, "After reaching timeout, getSession() should return incremented value.")
        XCTAssertGreaterThan(nextSession, initialSession, "After timeout is reached, session should be larger than the previous value." )
    }
    
    func testSessionManager_ReturnsNewSessionEachTime_IfTimeoutIsZero(){
        let dateProvider = CurrentTimeDateProvider()
        
        let manager = CIOSessionManager(dateProvider: dateProvider, timeout: 0)
        
        var lastSession = manager.getSession()
        
        for _ in 1...1000{
            let newSession = manager.getSession()
            XCTAssertEqual(lastSession + 1, newSession, "Session value should increment each time if timeout is zero.")
            lastSession = newSession
        }
    }
    
    func testSessionManager_IncrementsSession_AfterTimeoutIsReached(){
        let initialDate = Date()
        let initialTimeout: TimeInterval = 30
        
        let dateProvider = ClosureDateProvider { () -> Date in
            return initialDate
        }
        
        let manager = CIOSessionManager(dateProvider: dateProvider, timeout: initialTimeout)
        
        let initialSession = manager.getSession()
        
        dateProvider.provideDateClosure = {
            return initialDate.addingTimeInterval(initialTimeout+1)
        }
        
        let nextSession = manager.getSession()
        
        XCTAssertEqual(nextSession, initialSession+1, "After reaching timeout, getSession() should return incremented value.")
        XCTAssertGreaterThan(nextSession, initialSession, "After timeout is reached, session should be larger than the previous value." )
    }

    func testSessionManager_IncrementsSession_IfAppEntersForegroundAndTimesOut(){
        let expectation = self.expectation(description: "Invalid session should increment after application comes to foreground.")
        
        let timeout: TimeInterval = 0.05
        let sessionManager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: timeout)
        let delegate = ClosureSessionManagerDelegate { (from, to) in
            XCTAssertEqual(from, 1)
            XCTAssertEqual(to, 2)
            expectation.fulfill()
        }
        sessionManager.delegate = delegate
        
        // delay posting the notification so the session can time out
        sleep(1)
        
        NotificationCenter.default.post(Notification(name: Notification.Name.UIApplicationWillEnterForeground))
        
        self.wait(for: [expectation], timeout: 5.0)
    }
}
