//
//  URLSessionNetworkClient.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class URLSessionNetworkClient: NetworkClient {

    public func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void) {
        var req = request
        if request.url!.absoluteString.contains("search"){
            req = URLRequest(url: URL(string: "https://ac.cnstrc.com/search/lipstick?c=ciojs-search-1.20.0&key=u7PNVQx-prod-en-us&i=bbc0ed74-c2f5-44b8-9ee1-25381151b330&s=148&page=1&num_results_per_page=24&section=Products")!)
        }
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            // Check for errors
            if let error = error {
                let err: Error = CIOError(rawValue: (error as NSError).code) ?? error
                completionHandler(NetworkResponse(error: err))
                return
            }

            // Check for response code
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(NetworkResponse(error: CIOError.unknownError))
                return
            }

            // Check if response code corresponds to a ConstructorIOError
            if let constructorError = CIOError(rawValue: httpResponse.statusCode) {
                completionHandler(NetworkResponse(error: constructorError))
                return
            }

            // No errors
            guard let data = data else {
                completionHandler(NetworkResponse(error: CIOError.unknownError))
                return
            }

            completionHandler(NetworkResponse(data: data))
        }

        task.resume()

        ConstructorIO.logger.log(Constants.Logging.performURLRequest(request))
    }
}
