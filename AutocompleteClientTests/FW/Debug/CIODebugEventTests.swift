//
//  CIODebugEventTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class CIODebugEventTests: XCTestCase {

    let searchURL = "https://ac.cnstrc.com/autocomplete/corn/search?key=key_abc&original_query=co"
    let purchaseURL = "https://ac.cnstrc.com/v2/behavioral_action/purchase?key=key_abc"
    let timeout = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: [NSLocalizedDescriptionKey: "The request timed out."])

    // MARK: Request

    func testEvent_CapturesTheRequest() {
        let firedAt = Date(timeIntervalSince1970: 1_700_000_000)
        let request = self.makeRequest(self.purchaseURL, method: "POST", body: "{\"order_id\":\"order-1\"}")

        let event = CIODebugEvent(sequence: 7, name: .purchase, firedAt: firedAt, request: request, response: NetworkResponse(data: Data(), statusCode: 204))

        XCTAssertEqual(event.sequence, 7)
        XCTAssertEqual(event.name, .purchase)
        XCTAssertEqual(event.firedAt, firedAt)
        XCTAssertEqual(event.url, URL(string: self.purchaseURL))
        XCTAssertEqual(event.httpMethod, "POST")
        XCTAssertEqual(event.queryItems, [URLQueryItem(name: "key", value: "key_abc")])
        XCTAssertEqual(event.body, "{\"order_id\":\"order-1\"}")
    }

    func testEvent_WithoutARequestBody_HasNoBody() {
        let event = self.makeEvent(request: self.makeRequest(self.searchURL), response: NetworkResponse(data: Data(), statusCode: 204))

        XCTAssertEqual(event.httpMethod, "GET")
        XCTAssertNil(event.body)
    }

    func testQueryValue_ReturnsTheFirstDecodedValueWithThatName() {
        let request = self.makeRequest("https://ac.cnstrc.com/behavior?action=focus&term=red%20shoes&us=cio-app&us=cio-ios")
        let event = self.makeEvent(request: request, response: NetworkResponse(data: Data(), statusCode: 204))

        XCTAssertEqual(event.queryValue(for: "term"), "red shoes")
        XCTAssertEqual(event.queryValue(for: "us"), "cio-app", "The first of the repeated values should be returned.")
        XCTAssertNil(event.queryValue(for: "missing"))
    }

    // MARK: Outcome

    func testEvent_WithSuccessfulResponse_Succeeded() {
        let event = self.makeEvent(response: NetworkResponse(data: Data("accepted".utf8), statusCode: 200))

        XCTAssertTrue(event.succeeded)
        XCTAssertNil(event.error)
        XCTAssertNil(event.errorMessage)
        XCTAssertEqual(event.statusCode, 200)
        XCTAssertEqual(event.responseBody, "accepted")
        XCTAssertNil(event.underlyingError)
    }

    func testEvent_WithEmptyResponseBody_HasNoResponseBody() {
        let event = self.makeEvent(response: NetworkResponse(data: Data(), statusCode: 204))

        XCTAssertTrue(event.succeeded)
        XCTAssertNil(event.responseBody)
    }

    func testEvent_WithResponseWithoutStatusCode_Succeeded() {
        let event = self.makeEvent(response: NetworkResponse(data: Data()))

        XCTAssertTrue(event.succeeded)
        XCTAssertNil(event.statusCode)
        XCTAssertNil(event.errorMessage)
    }

    func testEvent_WithServerError_UsesTheServerMessage() {
        let body = "{\"message\":\"Invalid parameter\"}"
        let response = NetworkResponse(error: CIOError(errorType: .badRequest, errorMessage: "Invalid parameter"), statusCode: 400, body: Data(body.utf8))

        let event = self.makeEvent(response: response)

        XCTAssertFalse(event.succeeded)
        XCTAssertEqual(event.error as? CIOError, CIOError(errorType: .badRequest, errorMessage: "Invalid parameter"))
        XCTAssertEqual(event.statusCode, 400)
        XCTAssertEqual(event.responseBody, body)
        XCTAssertEqual(event.errorMessage, "Invalid parameter")
    }

    func testEvent_WithServerErrorWithoutMessage_DescribesTheStatusCode() {
        let event = self.makeEvent(response: NetworkResponse(error: CIOError(errorType: .unauthorized), statusCode: 401, body: nil))

        XCTAssertFalse(event.succeeded)
        XCTAssertEqual(event.errorMessage, "Error Code 401: Unauthorized - Your api key is wrong.")
    }

    func testEvent_WithEmptyServerMessage_DescribesTheStatusCode() {
        let response = NetworkResponse(error: CIOError(errorType: .badRequest, errorMessage: ""), statusCode: 400, body: Data("{\"message\":\"\"}".utf8))

        let event = self.makeEvent(response: response)

        XCTAssertEqual(event.errorMessage, "Error Code 400: Bad Request - Your request is invalid.")
    }

    func testEvent_WithTransportError_UsesTheTransportError() {
        let response = NetworkResponse(error: CIOError(errorType: .unknownError), statusCode: nil, body: nil, underlyingError: self.timeout)

        let event = self.makeEvent(response: response)

        XCTAssertFalse(event.succeeded)
        XCTAssertNil(event.statusCode)
        XCTAssertNil(event.responseBody)
        XCTAssertEqual((event.underlyingError as NSError?)?.code, NSURLErrorTimedOut)
        XCTAssertEqual(event.errorMessage, "The request timed out.")
    }

    func testEvent_WithStatusCodeTheSDKDoesNotMap_FailedAlthoughThereIsNoError() {
        let event = self.makeEvent(response: NetworkResponse(data: Data("Bad Gateway".utf8), statusCode: 502))

        XCTAssertNil(event.error, "The error mirrors what the completion handler received, which is a success for this status code.")
        XCTAssertFalse(event.succeeded, "Any status code outside of the 2xx range should make the event fail.")
        XCTAssertEqual(event.statusCode, 502)
        XCTAssertEqual(event.responseBody, "Bad Gateway")
        XCTAssertEqual(event.errorMessage, "HTTP 502: \(HTTPURLResponse.localizedString(forStatusCode: 502))")
    }

    func testEvent_WithStatusCodeTheSDKDoesNotMap_UsesTheServerMessage() {
        let body = Data("{\"message\":\"items must not be empty\"}".utf8)

        let event = self.makeEvent(response: NetworkResponse(data: body, statusCode: 422))

        XCTAssertFalse(event.succeeded)
        XCTAssertEqual(event.errorMessage, "items must not be empty")
    }

    func testEvent_WithRedirectStatusCode_Failed() {
        let event = self.makeEvent(response: NetworkResponse(data: Data(), statusCode: 304))

        XCTAssertFalse(event.succeeded)
    }

    func testEvent_WithErrorThatIsNotACIOError_UsesItsDescription() {
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Something else went wrong."])

        let event = self.makeEvent(response: NetworkResponse(error: error))

        XCTAssertFalse(event.succeeded)
        XCTAssertEqual(event.errorMessage, "Something else went wrong.")
    }

    func testEvent_WithErrorWithoutADescription_StillHasAnErrorMessage() {
        let error = NSError(domain: "test", code: 7, userInfo: [NSLocalizedDescriptionKey: ""])

        let event = self.makeEvent(response: NetworkResponse(error: error))

        XCTAssertFalse(event.succeeded)
        XCTAssertEqual(event.errorMessage?.isEmpty, false)
    }

    func testEvent_WithResponseBodyThatIsNotUTF8_KeepsAReadableBody() {
        let latin1Body = Data([0xE9, 0x63, 0x68, 0x65, 0x63])
        let response = NetworkResponse(error: CIOError(errorType: .internalServerError), statusCode: 500, body: latin1Body)

        let event = self.makeEvent(response: response)

        XCTAssertEqual(event.responseBody?.hasSuffix("chec"), true, "A body that is not valid UTF-8 should be decoded as far as possible instead of being dropped.")
    }

    func testEvent_HasAnErrorMessageExactlyWhenItFailed() {
        let json = Data("{\"message\":\"Invalid parameter\"}".utf8)
        let responses = [
            NetworkResponse(data: Data()),
            NetworkResponse(data: Data(), statusCode: 200),
            NetworkResponse(data: Data(), statusCode: 204),
            NetworkResponse(data: Data(), statusCode: 199),
            NetworkResponse(data: Data(), statusCode: 300),
            NetworkResponse(data: json, statusCode: 422),
            NetworkResponse(data: Data(), statusCode: 502),
            NetworkResponse(error: CIOError(errorType: .badRequest, errorMessage: "Invalid parameter"), statusCode: 400, body: json),
            NetworkResponse(error: CIOError(errorType: .badRequest, errorMessage: ""), statusCode: 400, body: nil),
            NetworkResponse(error: CIOError(errorType: .internalServerError), statusCode: 500, body: nil),
            NetworkResponse(error: CIOError(errorType: .noConnection), statusCode: nil, body: nil, underlyingError: self.timeout),
            NetworkResponse(error: CIOError(errorType: .unknownError), statusCode: 200, body: nil, underlyingError: self.timeout),
            NetworkResponse(error: CIOError(errorType: .unknownError)),
            NetworkResponse(error: self.timeout),
            NetworkResponse(error: NSError(domain: "test", code: 7, userInfo: [NSLocalizedDescriptionKey: ""])),
            NetworkResponse(error: CIOError(errorType: .unknownError), statusCode: nil, body: nil, underlyingError: NSError(domain: "test", code: 7, userInfo: [NSLocalizedDescriptionKey: ""]))
        ]

        for response in responses {
            let event = self.makeEvent(response: response)
            XCTAssertEqual(event.errorMessage == nil, event.succeeded, "\(event)")
            XCTAssertNotEqual(event.errorMessage, "", "\(event)")
        }
    }

    // MARK: Description

    func testDescription_OfASuccessfulEvent() {
        let event = self.makeEvent(sequence: 3, name: .searchSubmit, request: self.makeRequest(self.searchURL), response: NetworkResponse(data: Data("accepted".utf8), statusCode: 200))

        XCTAssertEqual(event.description, """
        #3 search_submit OK
          GET https://ac.cnstrc.com/autocomplete/corn/search?key=key_abc&original_query=co
        """)
    }

    func testDescription_OfASuccessfulEventWithARequestBody_IncludesTheBody() {
        let request = self.makeRequest(self.purchaseURL, method: "POST", body: "{\"order_id\":\"order-1\"}")
        let event = self.makeEvent(sequence: 4, name: .purchase, request: request, response: NetworkResponse(data: Data(), statusCode: 204))

        XCTAssertEqual(event.description, """
        #4 purchase OK
          POST https://ac.cnstrc.com/v2/behavioral_action/purchase?key=key_abc
          body: {"order_id":"order-1"}
        """)
    }

    func testDescription_OfAFailedEvent_AddsStatusCodeErrorAndResponseBody() {
        let request = self.makeRequest(self.purchaseURL, method: "POST", body: "{\"order_id\":\"order-1\"}")
        let responseBody = Data("{\"message\":\"Invalid parameter\"}".utf8)
        let response = NetworkResponse(error: CIOError(errorType: .badRequest, errorMessage: "Invalid parameter"), statusCode: 400, body: responseBody)

        let event = self.makeEvent(sequence: 5, name: .purchase, request: request, response: response)

        XCTAssertEqual(event.description, """
        #5 purchase FAILED
          POST https://ac.cnstrc.com/v2/behavioral_action/purchase?key=key_abc
          body: {"order_id":"order-1"}
          status code: 400
          error: Invalid parameter
          response: {"message":"Invalid parameter"}
        """)
    }

    func testDescription_OfAnEventThatGotNoResponse_AddsTheTransportError() {
        let response = NetworkResponse(error: CIOError(errorType: .unknownError), statusCode: nil, body: nil, underlyingError: self.timeout)

        let event = self.makeEvent(sequence: 6, name: .inputFocus, request: self.makeRequest("https://ac.cnstrc.com/behavior?action=focus"), response: response)

        XCTAssertEqual(event.description, """
        #6 input_focus FAILED
          GET https://ac.cnstrc.com/behavior?action=focus
          error: The request timed out.
        """)
    }

    // MARK: Helpers

    private func makeRequest(_ urlString: String, method: String = "GET", body: String? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method
        request.httpBody = body?.data(using: .utf8)
        return request
    }

    private func makeEvent(sequence: Int = 1, name: CIOTrackingEventName = .searchSubmit, request: URLRequest? = nil, response: NetworkResponse) -> CIODebugEvent {
        return CIODebugEvent(sequence: sequence, name: name, firedAt: Date(), request: request ?? self.makeRequest(self.searchURL), response: response)
    }
}
