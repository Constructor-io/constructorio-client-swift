//
//  CIODebugEventLog.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/// In-memory history of debug events backing the debug overlay. Main thread only.
final class CIODebugEventLog {

    static let shared = CIODebugEventLog()

    static let didChangeNotification = Notification.Name("CIODebugEventLogDidChange")

    // Bounds memory use if debug mode is left on for a long session
    static let capacity = 500

    /// Newest first
    private(set) var events: [CIODebugEvent] = []

    var failureCount: Int {
        return self.events.filter { !$0.succeeded }.count
    }

    func append(_ event: CIODebugEvent) {
        self.events.insert(event, at: 0)
        if self.events.count > CIODebugEventLog.capacity {
            self.events.removeLast(self.events.count - CIODebugEventLog.capacity)
        }
        self.notifyChange()
    }

    func clear() {
        self.events.removeAll()
        self.notifyChange()
    }

    private func notifyChange() {
        NotificationCenter.default.post(name: CIODebugEventLog.didChangeNotification, object: self)
    }
}
