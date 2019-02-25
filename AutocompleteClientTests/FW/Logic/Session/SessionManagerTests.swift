//
//  SessionManagerTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class SessionManagerTests: XCTestCase {

    func testSession_StartsAtOne() {
        let manager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: 30, sessionLoader: NoSessionLoader())
        XCTAssertEqual(manager.getSessionWithIncrement(), 1, "Initial session should be 1.")
    }

    func testSession_Stays_IfTimeoutIsNotReached() {
        let manager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: 30)
        let first = manager.getSessionWithIncrement()
        let second = manager.getSessionWithIncrement()
        XCTAssertEqual(first, second, "Calling getSessionWithIncrement multiple times before timing out should not increment the session.")
    }

    func testSession_Increments_IfTimeoutIsReached() {
        let initialDate = Date()
        let initialTimeout: TimeInterval = 30
        let dateProvider = ClosureDateProvider { () -> Date in
            return initialDate
        }
        let manager = CIOSessionManager(dateProvider: dateProvider, timeout: initialTimeout, sessionLoader: NoSessionLoader())
        let initialSession = manager.getSessionWithIncrement()

        dateProvider.provideDateClosure = {
            return Date(timeIntervalSince1970: manager.session.createdAt).addingTimeInterval(initialTimeout)
        }

        let nextSession = manager.getSessionWithIncrement()

        XCTAssertEqual(nextSession, initialSession+1, "After reaching timeout, getSessionWithIncrement() should return incremented value.")
    }

    func testSession_Increments_IfTimeoutIsZero() {
        let dateProvider = CurrentTimeDateProvider()

        let manager = CIOSessionManager(dateProvider: dateProvider, timeout: 0)

        var lastSession = manager.getSessionWithIncrement()

        for _ in 1...1000 {
            let newSession = manager.getSessionWithIncrement()
            XCTAssertEqual(lastSession + 1, newSession, "Session value should increment each time if timeout is zero.")
            lastSession = newSession
        }
    }

    func testSession_IsLoaded_WhenManagerIsInitialized() {
        let sessionLoader = CIOSessionLoader()
        let id = 19483
        let session = Session(id: id, createdAt: Date().timeIntervalSince1970)

        sessionLoader.clearSession()
        sessionLoader.saveSession(session)

        let manager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: 1800, sessionLoader: sessionLoader)

        XCTAssertEqual(session.id, manager.session.id, "Existing session should load when manager is initialized.")
    }

    func testSession_Increments_IfAppEntersForegroundAndTimesOut() {
        let expectation = self.expectation(description: "Invalid session should increment after application comes to foreground.")

        let timeout: TimeInterval = 0.05
        let sessionManager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: timeout, sessionLoader: NoSessionLoader())
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

    func testSession_IsStoredSuccessfully_AfterCallingSave() {
        let loader = CIOSessionLoader()

        let id = Int(arc4random()) % Int.max
        let session = Session(id: id, createdAt: Date().timeIntervalSince1970)

        loader.saveSession(session)

        let loadedSession = loader.loadSession()
        XCTAssertNotNil(loadedSession, "After calling save, session should be loadable.")
        XCTAssertEqual(session.id, loadedSession!.id, "Loaded session should have the same id.")
    }

    func testSession_IsCleared_AfterCallingClearSession() {
        let loader = CIOSessionLoader()

        let id = Int(arc4random()) % Int.max
        let session = Session(id: id, createdAt: Date().timeIntervalSince1970)

        loader.saveSession(session)

        let loadedSession = loader.loadSession()
        XCTAssertNotNil(loadedSession, "After calling save, session should be loadable.")

        loader.clearSession()

        let loadedSessionAfterClear = loader.loadSession()
        XCTAssertNil(loadedSessionAfterClear, "After calling clear, session should be nil.")
    }
}
