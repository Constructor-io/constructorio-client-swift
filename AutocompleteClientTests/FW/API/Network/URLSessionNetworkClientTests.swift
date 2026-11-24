//
//  URLSessionNetworkClientTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class URLSessionNetworkClientTests: XCTestCase {

    // A reserved test domain, so a request that misses its stub fails instead of reaching a real server
    let endpoint = "https://network-client.cnstrc.test/track"

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testExecute_WithSuccess_KeepsStatusCodeAndBody() {
        let body = Data("{\"result\":\"ok\"}".utf8)
        stub(regex(self.endpoint), http(200, data: body))

        let response = self.execute(self.endpoint)

        XCTAssertNil(response?.error, "A 200 response should not produce an error.")
        XCTAssertEqual(response?.data, body)
        XCTAssertEqual(response?.statusCode, 200)
        XCTAssertEqual(response?.body, body)
        XCTAssertNil(response?.underlyingError)
    }

    func testExecute_WithMappedErrorStatus_KeepsStatusCodeAndBody() {
        let body = Data("{\"message\":\"Invalid parameter\"}".utf8)
        stub(regex(self.endpoint), http(400, data: body))

        let response = self.execute(self.endpoint)

        XCTAssertEqual(response?.error as? CIOError, CIOError(errorType: .badRequest, errorMessage: "Invalid parameter"))
        XCTAssertNil(response?.data)
        XCTAssertEqual(response?.statusCode, 400)
        XCTAssertEqual(response?.body, body, "The raw body of a failed request should be kept.")
        XCTAssertNil(response?.underlyingError)
    }

    func testExecute_WithUnmappedStatus_StillSucceedsAndKeepsStatusCodeAndBody() {
        let body = Data("Bad Gateway".utf8)
        stub(regex(self.endpoint), http(502, data: body))

        let response = self.execute(self.endpoint)

        XCTAssertNil(response?.error, "A status code without a matching CIOErrorType should keep being reported as a success.")
        XCTAssertEqual(response?.data, body)
        XCTAssertEqual(response?.statusCode, 502)
        XCTAssertEqual(response?.body, body)
        XCTAssertNil(response?.underlyingError)
    }

    func testExecute_WithTransportError_KeepsUnderlyingError() {
        stub(regex(self.endpoint)) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: [NSLocalizedDescriptionKey: "The request timed out."])
            return OHHTTPStubsResponse(error: error)
        }

        let response = self.execute(self.endpoint)

        XCTAssertEqual(response?.error as? CIOError, CIOError(errorType: .unknownError))
        XCTAssertNil(response?.data)
        XCTAssertNil(response?.statusCode, "A request that got no response should have no status code.")
        XCTAssertNil(response?.body)
        let underlyingError = response?.underlyingError as NSError?
        XCTAssertEqual(underlyingError?.domain, NSURLErrorDomain)
        XCTAssertEqual(underlyingError?.code, NSURLErrorTimedOut)
    }

    func testExecute_WithNoConnectivity_KeepsUnderlyingError() {
        stub(regex(self.endpoint), noConnectivity())

        let response = self.execute(self.endpoint)

        XCTAssertEqual(response?.error as? CIOError, CIOError(errorType: .noConnection))
        XCTAssertNil(response?.statusCode)
        let underlyingError = response?.underlyingError as NSError?
        XCTAssertEqual(underlyingError?.domain, NSURLErrorDomain)
        XCTAssertEqual(underlyingError?.code, NSURLErrorNotConnectedToInternet)
    }

    func testExecute_WithNonHTTPResponse_KeepsBody() {
        // A data URL is answered without an HTTP response
        let response = self.execute("data:text/plain,hello")

        XCTAssertEqual(response?.error as? CIOError, CIOError(errorType: .unknownError))
        XCTAssertNil(response?.statusCode)
        XCTAssertEqual(response?.body, Data("hello".utf8))
        XCTAssertNil(response?.underlyingError)
    }

    private func execute(_ urlString: String) -> NetworkResponse? {
        let expectation = self.expectation(description: "The network client should call its completion handler.")
        var networkResponse: NetworkResponse?
        URLSessionNetworkClient().execute(URLRequest(url: URL(string: urlString)!)) { response in
            networkResponse = response
            expectation.fulfill()
        }
        self.waitForExpectationWithDefaultHandler()
        return networkResponse
    }
}
