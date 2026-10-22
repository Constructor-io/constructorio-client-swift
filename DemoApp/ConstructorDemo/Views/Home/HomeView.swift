//
//  HomeView.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var search: SearchModel
    @EnvironmentObject private var featured: FeaturedModel
    @EnvironmentObject private var cart: Cart
    @Environment(\.selectTab) private var selectTab

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Groceries, delivered.").font(.title2.bold())
                        Text("Search the demo store, add items to your cart and check out. Every step sends a tracking event you can inspect with the SDK\u{2019}s debug button.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)

                    Button {
                        self.search.reset()
                        self.selectTab(.shop)
                    } label: {
                        // List rows tint a Label's icon separately from its text, so set both
                        Label("Start shopping", systemImage: "magnifyingglass")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }

                Section("Featured") {
                    self.carousel
                        .listRowInsets(EdgeInsets())
                }

                if self.cart.itemCount > 0 {
                    Section {
                        Button {
                            self.selectTab(.cart)
                        } label: {
                            Label("View cart (\(self.cart.itemCount))", systemImage: "cart")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .homeLogo()
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product, searchTerm: nil)
            }
            .onAppear(perform: self.featured.loadIfNeeded)
        }
    }

    @ViewBuilder
    private var carousel: some View {
        if self.featured.products.isEmpty {
            ProgressView()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 12) {
                    ForEach(self.featured.products) { product in
                        NavigationLink(value: product) {
                            ProductCard(product: product)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("featured-product")
                    }
                }
                .padding()
            }
        }
    }
}
