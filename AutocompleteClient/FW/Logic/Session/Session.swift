//
//  Session.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

let kSessionID = "id"
let kCreatedAt = "createdAt"

public class Session: NSObject, NSCoding{
    let id: Int
    let createdAt: TimeInterval
    
    public init(id: Int, createdAt: TimeInterval){
        self.id = id
        self.createdAt = createdAt
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: kSessionID)
        self.createdAt = aDecoder.decodeDouble(forKey: kCreatedAt)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: kSessionID)
        aCoder.encode(self.createdAt, forKey: kCreatedAt)
    }
}
