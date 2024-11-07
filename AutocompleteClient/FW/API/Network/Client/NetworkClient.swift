//
//  NetworkClient.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol NetworkClient {

    func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void)
}
