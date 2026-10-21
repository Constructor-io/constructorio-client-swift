//
//  RootView.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject private var cart: Cart

    var body: some View {
        TabView {
            SearchTab()
                .tabItem { Label("Shop", systemImage: "magnifyingglass") }

            CartView()
                .tabItem { Label("Cart", systemImage: "cart") }
                .badge(self.cart.itemCount)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}
