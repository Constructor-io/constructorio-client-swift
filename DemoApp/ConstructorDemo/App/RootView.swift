//
//  RootView.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import SwiftUI

enum DemoTab: Hashable {
    case home, shop, cart, settings
}

struct RootView: View {

    @EnvironmentObject private var cart: Cart
    @State private var selectedTab = DemoTab.home

    var body: some View {
        TabView(selection: self.$selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(DemoTab.home)

            SearchTab()
                .tabItem { Label("Shop", systemImage: "magnifyingglass") }
                .tag(DemoTab.shop)

            CartView()
                .tabItem { Label("Cart", systemImage: "cart") }
                .badge(self.cart.itemCount)
                .tag(DemoTab.cart)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(DemoTab.settings)
        }
        .environment(\.selectTab) { tab in self.selectedTab = tab }
    }
}

private struct SelectTabKey: EnvironmentKey {
    static let defaultValue: (DemoTab) -> Void = { _ in }
}

extension EnvironmentValues {
    /// Switches the root tab, so screens can send the user elsewhere in the app.
    var selectTab: (DemoTab) -> Void {
        get { self[SelectTabKey.self] }
        set { self[SelectTabKey.self] = newValue }
    }
}
