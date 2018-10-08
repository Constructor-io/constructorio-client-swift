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
    
    func test_SessionManager_HasCorrentInitialSession(){
        let manager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: 30)
        XCTAssertEqual(manager.getSession(), 1, "Initial session should be 1.")
    }
    
    func test_SessionManager_DoesNotIncrementAutomatically(){
        let manager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: 30)
        let first = manager.getSession()
        let second = manager.getSession()
        XCTAssertEqual(first, second, "Calling getSession multiple times before timing out should not increment the session.")
    }
    
    func test_SessionManager_DoesNotIncrementsSession_IfTimeoutIsNotReached(){
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
    
    func test_SessionManager_IncrementsSession_IfTimeoutIsReached(){
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
    
    func test_SessionManager_ReturnsNewSessionEachTime_IfTimeoutIsZero(){
        let dateProvider = CurrentTimeDateProvider()
        
        let manager = CIOSessionManager(dateProvider: dateProvider, timeout: 0)
        
        var lastSession = manager.getSession()
        
        for _ in 1...1000{
            let newSession = manager.getSession()
            XCTAssertEqual(lastSession + 1, newSession, "Session value should increment each time if timeout is zero.")
            lastSession = newSession
        }
    }
    
    func test_SessionManager_IncrementsSession_AfterTimeoutIsReached(){
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

}
