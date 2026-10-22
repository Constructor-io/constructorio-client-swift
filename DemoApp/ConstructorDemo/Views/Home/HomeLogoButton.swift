//
//  HomeLogoButton.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import SwiftUI

/// The shop's text logo, shown at the top of every screen. Tapping it goes to the Home tab.
private struct HomeLogoToolbar: ViewModifier {

    @Environment(\.selectTab) private var selectTab

    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    self.selectTab(.home)
                } label: {
                    Text("FreshCart")
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(.green)
                }
                .accessibilityLabel("Home")
                .accessibilityIdentifier("home-logo")
            }
        }
    }
}

extension View {
    func homeLogo() -> some View {
        return self.modifier(HomeLogoToolbar())
    }
}
