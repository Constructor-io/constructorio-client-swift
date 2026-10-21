//
//  CartView.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import SwiftUI

struct CartView: View {

    @EnvironmentObject private var service: ConstructorService
    @EnvironmentObject private var cart: Cart
    @State private var lastOrderID: String?

    var body: some View {
        NavigationStack {
            List {
                if self.cart.lines.isEmpty {
                    Section {
                        Text("Your cart is empty. Add items from a product page.").foregroundStyle(.secondary)
                    }
                } else {
                    Section {
                        ForEach(self.cart.lines) { line in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(line.product.name)
                                    Text("Qty \(line.quantity)").font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(Optional(line.subtotal).formattedPrice)
                            }
                        }
                        .onDelete(perform: self.cart.remove(atOffsets:))
                    }

                    Section {
                        HStack {
                            Text("Total").bold()
                            Spacer()
                            Text(Optional(self.cart.total).formattedPrice).bold()
                        }
                        Button(action: self.placeOrder) {
                            Label("Place Order", systemImage: "creditcard").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Cart")
            .alert("Order placed", isPresented: Binding(get: { self.lastOrderID != nil }, set: { if !$0 { self.lastOrderID = nil } })) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Thanks! Your order \(self.lastOrderID ?? "") is on its way.")
            }
        }
    }

    private func placeOrder() {
        let orderID = "demo-" + UUID().uuidString.prefix(8).lowercased()
        let items = self.cart.lines.map { line in
            CIOItem(customerID: line.product.customerID, itemName: line.product.name, variationID: line.product.variationID, quantity: line.quantity)
        }
        self.service.constructor.trackPurchase(items: items, revenue: self.cart.total, orderID: orderID)
        self.cart.clear()
        self.lastOrderID = orderID
    }
}
