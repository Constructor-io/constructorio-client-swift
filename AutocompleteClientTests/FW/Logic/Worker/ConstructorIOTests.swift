//
//  ConstructorIOTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class ConstructorIOTests: XCTestCase {

    var networkClient: NetworkClient!
    let piiParams = [
        // Email
        "test@test.com",
        "test-100@test.com",
        "test.100@test.com",
        "test@test.com",
        "test+123@test.info",
        "test-100@test.net",
        "test.100@test.com.au",
        "test@test.io",
        "test@test.com.com",
        "test+100@test.com",
        "test-100@test-test.io",
        // Phone Number
        "+12363334011",
        "+1 236 333 4011",
        "(236)2228542",
        "(236) 222 8542",
        "(236)222-8542",
        "(236) 222-8542",
        "+420736447763",
        "+420 736 447 763",
        // Sources of example card numbers:
        // - https://support.bluesnap.com/docs/test-credit-card-numbers
        // - https://www.paypalobjects.com/en_GB/vhelp/paypalmanager_help/credit_card_numbers.htm
        "4263982640269299", // Visa
        "4917484589897107", // Visa
        "4001919257537193", // Visa
        "4007702835532454", // Visa
        "4111111111111111", // Visa
        "4012888888881881", // Visa
        "5425233430109903", // MasterCard
        "2222420000001113", // MasterCard
        "2223000048410010", // MasterCard
        "5555555555554444", // MasterCard
        "5105105105105100", // MasterCard
        "374245455400126", // American Express
        "378282246310005", // American Express
        "371449635398431", // American Express
        "378734493671000", // American Express
        "6011556448578945", // Discover
        "6011000991300009", // Discover
        "6011111111111117", // Discover
        "6011000990139424", // Discover
        "3566000020000410", // JCB
        "3530111333300000", // JCB
        "3566002020360505", // JCB
        "30569309025904", // Diners Club
        "38520000023237", // Diners Club
    ]

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
        DependencyContainer.sharedInstance.networkClient = { return MockNetworkClient() }

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
        DependencyContainer.sharedInstance.networkClient = { return MockNetworkClient(error: customError) }

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
        DependencyContainer.sharedInstance.networkClient = { return MockNetworkClient() }

        let constructor = TestConstants.testConstructor()

        let query = CIOAutocompleteQuery(query: "term")
        constructor.autocomplete(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, description)
            if let err = response.error as? CIOError {
                XCTAssertEqual(err.errorType, .invalidResponse, description)

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

    func testConstructor_requestsWithPiiInPathAreDetected() {
        let constructor = TestConstants.testConstructor()
        var url: String

        for pathParam in piiParams {
            url = "https://ac.cnstrc.com/autocomplete/\(pathParam)/search?_dt=test&c=test&i=test&key=test&original_query=test&s=test"
            XCTAssertTrue(constructor.requestContainsPII(request: url), "Path param containing PII is detected")
        }
    }

    func testConstructor_requestsWithPiiInQueryParamsAreDetected() {
        let constructor = TestConstants.testConstructor()
        var url: String

        for queryParam in piiParams {
            url = "https://ac.cnstrc.com/autocomplete/test/search?_dt=test&c=test&i=test&key=test&original_query=\(queryParam)&s=test"
            XCTAssertTrue(constructor.requestContainsPII(request: url), "Path param containing PII is detected")
        }
    }
}
