//
//  SettingsView.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject private var service: ConstructorService
    @State private var apiKey = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("API key", text: self.$apiKey)
                        .font(.body.monospaced())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onSubmit(self.applyKey)
                    Button("Apply", action: self.applyKey)
                        .disabled(self.trimmedKey.isEmpty || self.trimmedKey == self.service.apiKey)
                    Button("Reset to demo index") {
                        self.apiKey = DemoConfig.defaultAPIKey
                        self.applyKey()
                    }
                    .disabled(self.service.apiKey == DemoConfig.defaultAPIKey)
                } header: {
                    Text("Constructor index")
                }

                Section {
                    Toggle("SDK debug mode", isOn: Binding(
                        get: { self.service.debugMode },
                        set: { enabled in
                            self.service.debugMode = enabled
                            UserDefaults.standard.set(enabled, forKey: DemoConfig.debugModeDefaultsKey)
                        }
                    ))
                } footer: {
                    Text("Sets ConstructorIOConfig.debugMode, the same flag a customer would set.")
                }
            }
            .navigationTitle("Settings")
            .homeLogo()
            .onAppear { self.apiKey = self.service.apiKey }
        }
    }

    private var trimmedKey: String {
        return self.apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func applyKey() {
        guard !self.trimmedKey.isEmpty, self.trimmedKey != self.service.apiKey else { return }
        UserDefaults.standard.set(self.trimmedKey, forKey: DemoConfig.apiKeyDefaultsKey)
        self.service.reconfigure(apiKey: self.trimmedKey)
    }
}
