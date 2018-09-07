//
//  MockCommons.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import OHHTTPStubs

public typealias Matcher = OHHTTPStubsTestBlock
public typealias Builder = OHHTTPStubsResponseBlock

public func http(_ statusCode: Int32) -> OHHTTPStubsResponseBlock{
    return { _ in
        let data = "".data(using: String.Encoding.utf8)!
        return OHHTTPStubsResponse(data: data, statusCode: statusCode, headers: nil)
    }
}

@discardableResult
public func stub(_ matcher: @escaping Matcher, _ builder: @escaping Builder) -> OHHTTPStubsDescriptor{
    return stub(condition: matcher, response: builder)
}
