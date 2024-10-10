//
//  NSError+Unknown.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

let kConstructorUnknownErrorCode = 0xf
let kConstructorJSONErrorCode = 0xf0

extension NSError {
    class func unknownError() -> NSError {
        return NSError(domain: "unknownError", code: kConstructorUnknownErrorCode, userInfo: nil)
    }

    class func jsonParseError() -> NSError {
        return NSError(domain: "jsonParseError", code: kConstructorJSONErrorCode, userInfo: nil)
    }
}
