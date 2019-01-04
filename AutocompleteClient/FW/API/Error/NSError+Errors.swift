//
//  NSError+Unknown.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public let kConstructorUnknownErrorCode = 0xf
public let kConstructorJSONErrorCode = 0xf0

public extension NSError {
    public class func unknownError() -> NSError {
        return NSError(domain: "unknownError", code: kConstructorUnknownErrorCode, userInfo: nil)
    }

    public class func jsonParseError() -> NSError {
        return NSError(domain: "jsonParseError", code: kConstructorJSONErrorCode, userInfo: nil)
    }
}
