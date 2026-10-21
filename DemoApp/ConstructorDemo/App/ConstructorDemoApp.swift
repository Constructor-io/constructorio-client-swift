//
//  ConstructorDemoApp.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import SwiftUI

@main
struct ConstructorDemoApp: App {

    @StateObject private var service: ConstructorService
    @StateObject private var search: SearchModel
    @StateObject private var cart = Cart()

    init() {
        let defaults = UserDefaults.standard
        let apiKey = defaults.string(forKey: DemoConfig.apiKeyDefaultsKey) ?? DemoConfig.defaultAPIKey
        // On unless turned off. bool(forKey:) also parses "YES"/"NO" passed as launch arguments.
        let debugMode = defaults.object(forKey: DemoConfig.debugModeDefaultsKey) == nil || defaults.bool(forKey: DemoConfig.debugModeDefaultsKey)
        let service = ConstructorService(apiKey: apiKey, debugMode: debugMode)
        _service = StateObject(wrappedValue: service)
        _search = StateObject(wrappedValue: SearchModel(service: service))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(self.service)
                .environmentObject(self.search)
                .environmentObject(self.cart)
        }
    }
}
