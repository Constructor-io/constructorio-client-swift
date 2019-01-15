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

    private(set) public var session: Session {
        didSet {
            self.sessionLoader.saveSession(self.session)
            self.delegate?.sessionDidChange(from: oldValue.id, to: self.session.id)
        }
    }
    let timeout: TimeInterval
    let dateProvider: DateProvider
    let sessionLoader: SessionLoader

    public init(dateProvider: DateProvider, timeout: TimeInterval, sessionLoader: SessionLoader = CIOSessionLoader()) {
        self.dateProvider = dateProvider
        self.timeout = timeout

        self.sessionLoader = sessionLoader
        self.session = self.sessionLoader.loadSession() ?? Session(id: 1, createdAt: dateProvider.provideDate().timeIntervalSince1970)

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterForeground(_:)), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    public func setup() {
        self.reloadSession()
        self.sessionLoader.saveSession(self.session)
    }

    @objc
    public func applicationDidEnterForeground(_ notification: Notification) {
        self.reloadSession()
    }

    public func getSessionWithIncrement() -> Int {
        self.reloadSession()
        return self.session.id
    }

    public func getSessionWithoutIncrement() -> Int {
        return self.session.id
    }

    public func reloadSession() {
        if self.shouldIncrementSession() {
            self.incrementSession()
        }
    }

    public func shouldIncrementSession() -> Bool {
        let diff = (self.dateProvider.provideDate().timeIntervalSince1970 - self.session.createdAt)
        return diff >= self.timeout
    }

    public func incrementSession() {
        self.session = Session(id: self.session.id + 1, createdAt: self.dateProvider.provideDate().timeIntervalSince1970)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
