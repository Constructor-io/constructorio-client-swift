//
//  CIOSessionManager.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

class CIOSessionManager: SessionManager {

    weak var delegate: CIOSessionManagerDelegate?

    private(set) var session: Session {
        didSet {
            self.sessionLoader.saveSession(self.session)
            self.delegate?.sessionDidChange(from: oldValue.id, to: self.session.id)
        }
    }
    let timeout: TimeInterval
    let dateProvider: DateProvider
    let sessionLoader: SessionLoader

    init(dateProvider: DateProvider, timeout: TimeInterval, sessionLoader: SessionLoader = CIOSessionLoader()) {
        self.dateProvider = dateProvider
        self.timeout = timeout

        self.sessionLoader = sessionLoader
        self.session = self.sessionLoader.loadSession() ?? Session(id: 1, createdAt: dateProvider.provideDate().timeIntervalSince1970)

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    func setup() {
        self.reloadSession()
        self.sessionLoader.saveSession(self.session)
    }

    @objc
    func applicationDidEnterForeground(_ notification: Notification) {
        self.reloadSession()
    }

    func getSessionWithIncrement() -> Int {
        self.reloadSession()
        return self.session.id
    }

    func getSessionWithoutIncrement() -> Int {
        return self.session.id
    }

    func reloadSession() {
        if self.shouldIncrementSession() {
            self.incrementSession()
        }
    }

    func shouldIncrementSession() -> Bool {
        let diff = (self.dateProvider.provideDate().timeIntervalSince1970 - self.session.createdAt)
        return diff >= self.timeout
    }

    func incrementSession() {
        self.session = Session(id: self.session.id + 1, createdAt: self.dateProvider.provideDate().timeIntervalSince1970)
    }

    func setSessionID(id: Int) {
        self.session = Session(id: id, createdAt: self.dateProvider.provideDate().timeIntervalSince1970)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
