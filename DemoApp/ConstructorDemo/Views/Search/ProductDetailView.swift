//
//  ProductDetailView.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import SwiftUI

struct ProductDetailView: View {

    let product: Product
    let searchTerm: String?

    @EnvironmentObject private var service: ConstructorService
    @EnvironmentObject private var cart: Cart
    @State private var hasTrackedLoad = false
    @State private var justAdded = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ProductImage(url: self.product.imageURL)
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)

                Text(self.product.name).font(.title2.bold())
                Text(self.product.price.formattedPrice).font(.title3)

                if let details = self.product.details, !details.isEmpty {
                    Text(details).foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Item ID: \(self.product.customerID)")
                    if let variationID = self.product.variationID {
                        Text("Variation ID: \(variationID)")
                    }
                }
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: self.addToCart) {
                Label(self.justAdded ? "Added" : "Add to Cart", systemImage: self.justAdded ? "checkmark" : "cart.badge.plus").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding()
            .background(.bar)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: self.trackLoadOnce)
    }

    // onAppear fires again when navigating back to this screen; the item was only loaded once
    private func trackLoadOnce() {
        guard !self.hasTrackedLoad else { return }
        self.hasTrackedLoad = true
        self.service.constructor.trackItemDetailLoad(customerID: self.product.customerID, itemName: self.product.name, variationID: self.product.variationID, url: self.product.url)
    }

    private func addToCart() {
        self.cart.add(self.product)
        self.justAdded = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { self.justAdded = false }
        self.service.constructor.trackConversion(itemName: self.product.name, customerID: self.product.customerID, variationID: self.product.variationID, revenue: self.product.price, searchTerm: self.searchTerm, conversionType: "add_to_cart")
    }
}
