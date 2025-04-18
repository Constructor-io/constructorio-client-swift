//
//  Session.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class Session: NSObject, NSCoding {
    public var id: Int
    public let createdAt: TimeInterval

    public init(id: Int, createdAt: TimeInterval) {
        self.id = id
        self.createdAt = createdAt
    }

    public required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: Constants.Session.id)
        self.createdAt = aDecoder.decodeDouble(forKey: Constants.Session.createdAt)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: Constants.Session.id)
        aCoder.encode(self.createdAt, forKey: Constants.Session.createdAt)
    }

    public func setSessionID(sessionID: Int) {
        self.id = sessionID
    }
}
