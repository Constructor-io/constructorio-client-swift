//
//  ConstructorService.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import Foundation

/// Owns the ConstructorIO client, the way a customer app would.
final class ConstructorService: ObservableObject {

    @Published private(set) var constructor: ConstructorIO
    @Published private(set) var apiKey: String

    @Published var debugMode: Bool {
        didSet { self.constructor.config.debugMode = self.debugMode }
    }

    init(apiKey: String, debugMode: Bool) {
        self.apiKey = apiKey
        self.debugMode = debugMode
        self.constructor = ConstructorService.makeClient(apiKey: apiKey, debugMode: debugMode)
    }

    func reconfigure(apiKey: String) {
        self.apiKey = apiKey
        self.constructor = ConstructorService.makeClient(apiKey: apiKey, debugMode: self.debugMode)
    }

    private static func makeClient(apiKey: String, debugMode: Bool) -> ConstructorIO {
        let config = ConstructorIOConfig(apiKey: apiKey, segments: ["demo-app"], debugMode: debugMode)
        return ConstructorIO(config: config)
    }
}
