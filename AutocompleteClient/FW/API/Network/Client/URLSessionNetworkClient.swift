//
//  URLSessionNetworkClient.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

class URLSessionNetworkClient: NetworkClient {

    func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var errorMessage: String?

            // Check for transport errors
            if let error = error {
                let err: Error = CIOError(errorType: CIOErrorType(rawValue: (error as NSError).code) ?? CIOErrorType.unknownError)
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                completionHandler(NetworkResponse(error: err, statusCode: statusCode, body: data, underlyingError: error))
                return
            }

            // Check for response code
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(NetworkResponse(error: CIOError(errorType: .unknownError), statusCode: nil, body: data))
                return
            }

            ConstructorIO.logger.log(Constants.Logging.recieveURLResponse(httpResponse))

            let statusCode = httpResponse.statusCode

            // Check the response for an error message
            let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            if jsonObj != nil {
                errorMessage = jsonObj?["message"] as? String
            }

            // Check if response code corresponds to a ConstructorIOError
            let constructorErrorType = CIOErrorType(rawValue: statusCode)
            if constructorErrorType != nil {
                let constructorError = CIOError(errorType: constructorErrorType!, errorMessage: errorMessage)
                completionHandler(NetworkResponse(error: constructorError, statusCode: statusCode, body: data))
                return
            }

            // No errors
            guard let data = data else {
                completionHandler(NetworkResponse(error: CIOError(errorType: .unknownError, errorMessage: errorMessage), statusCode: statusCode, body: nil))
                return
            }

            completionHandler(NetworkResponse(data: data, statusCode: statusCode))
        }

        task.resume()

        ConstructorIO.logger.log(Constants.Logging.performURLRequest(request))
    }
}
