//
//  MockCommons.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import OHHTTPStubs
import XCTest

public typealias Matcher = OHHTTPStubsTestBlock
public typealias Builder = OHHTTPStubsResponseBlock

public func http(_ statusCode: Int32, data: Data = "".data(using: String.Encoding.utf8)!) -> OHHTTPStubsResponseBlock {
    return { _ in
        return OHHTTPStubsResponse(data: data, statusCode: statusCode, headers: nil)
    }
}

public func noConnectivity() -> OHHTTPStubsResponseBlock {
    return { _ in
        let error = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue, userInfo: nil)
        return OHHTTPStubsResponse(error: error)
    }
}

@discardableResult
public func stub(_ matcher: @escaping Matcher, _ builder: @escaping Builder) -> OHHTTPStubsDescriptor {
    return stub(condition: matcher, response: builder)
}
