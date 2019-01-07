//
//  ConstructorIOTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class ConstructorIOTests: XCTestCase {

    var networkClient: NetworkClient!

    override  func setUp() {
        super.setUp()
        self.networkClient = DependencyContainer.sharedInstance.networkClient()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        DependencyContainer.sharedInstance.networkClient = { self.networkClient }
    }

    func testConstructor_returnsNonNilResponse_ifDataIsValid() {
        let description = "Calling autocomplete method should return non-nil object if the network client returns valid data."
        let exp = self.expectation(description: description)
        class MockNetworkClient: NetworkClient {
            func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void) {
                let data = TestResource.load(name: TestResource.Response.singleSectionJSONFilename)
                completionHandler(NetworkResponse(data: data))
            }
        }

        // mock out the network client
        DependencyContainer.sharedInstance.networkClient = { return MockNetworkClient () }

        let constructor = TestConstants.testConstructor()

        let query = CIOAutocompleteQuery(query: "term")
        constructor.autocomplete(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, description)
            exp.fulfill()
        })
        self.waitForExpectationWithDefaultHandler()
    }

    func testConstructor_delegatesNetworkClientError() {
        let description = "Calling autocomplete method should delegate the network client error if it returs one."
        let exp = self.expectation(description: description)

        let customErrorCode = 0xbeef
        let customError = NSError(domain: "", code: customErrorCode, userInfo: nil)

        class MockNetworkClient: NetworkClient {

            let error: NSError

            init(error: NSError) {
                self.error = error
            }

            func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void) {
                completionHandler(NetworkResponse(error: self.error))
            }
        }

        // mock out the network client
        DependencyContainer.sharedInstance.networkClient = { return MockNetworkClient (error: customError) }

        let constructor = TestConstants.testConstructor()

        let query = CIOAutocompleteQuery(query: "term")
        constructor.autocomplete(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, description)
            if let err = response.error as NSError? {
                XCTAssertEqual(err, customError, description)
            } else {
                XCTFail(description)
            }
            exp.fulfill()
        })
        self.waitForExpectationWithDefaultHandler()
    }

    func testConstructor_returnsInvalidResponseError_ifDataIsntParsable() {
        let description = "Calling autocomplete method should return .invalidResponse CIOError object if data is not parsable"
        let exp = self.expectation(description: description)

        class MockNetworkClient: NetworkClient {
            func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void) {
                let data = "not your usual json string".data(using: String.Encoding.utf8)!
                completionHandler(NetworkResponse(data: data))
            }
        }

        // mock out the network client
        DependencyContainer.sharedInstance.networkClient = { return MockNetworkClient () }

        let constructor = TestConstants.testConstructor()

        let query = CIOAutocompleteQuery(query: "term")
        constructor.autocomplete(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, description)
            if let err = response.error as? CIOError {
                XCTAssertEqual(err, .invalidResponse, description)

                exp.fulfill()
            } else {
                // error not a CIOError
                XCTFail("Error returned should be of type CIOError.")
            }
        })
        self.waitForExpectationWithDefaultHandler()
    }

    func testConstructor_sessionIDPropertyIsAccessible() {
        let constructor = TestConstants.testConstructor()

        XCTAssertNotNil(constructor.sessionID, "Session ID shouldn't be nil")
    }

    func testConstructor_clientIDPropertyIsAccessible() {
        let constructor = TestConstants.testConstructor()

        XCTAssertNotNil(constructor.clientID, "Client ID shouldn't be nil")
    }

}
