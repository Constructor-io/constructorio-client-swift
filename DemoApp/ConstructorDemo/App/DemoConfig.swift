//
//  DemoConfig.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

enum DemoConfig {
    /// Public demo index (a grocery store), the same one used by the UserApplication sample. Can be changed in Settings.
    static let defaultAPIKey = "key_K2hlXt5aVSwoI1Uw"

    static let apiKeyDefaultsKey = "demo.apiKey"
    static let debugModeDefaultsKey = "demo.debugMode"

    /// The repo's debug/journeys.json, found from this source file's location. Works in the simulator, which can read the Mac's files.
    static let journeysURL = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent() // App
        .deletingLastPathComponent() // ConstructorDemo
        .deletingLastPathComponent() // DemoApp
        .deletingLastPathComponent() // repo root
        .appendingPathComponent("debug/journeys.json")

    static let suggestionsSectionName = "Search Suggestions"

    static let resultsPerPage = 20
}
