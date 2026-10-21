//
//  Cart.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

final class Cart: ObservableObject {

    struct Line: Identifiable {
        let product: Product
        var quantity: Int

        var id: String {
            return self.product.id
        }

        var subtotal: Double {
            return (self.product.price ?? 0) * Double(self.quantity)
        }
    }

    @Published private(set) var lines: [Line] = []

    var itemCount: Int {
        return self.lines.reduce(0) { $0 + $1.quantity }
    }

    var total: Double {
        return self.lines.reduce(0) { $0 + $1.subtotal }
    }

    func add(_ product: Product) {
        if let index = self.lines.firstIndex(where: { $0.id == product.id }) {
            self.lines[index].quantity += 1
        } else {
            self.lines.append(Line(product: product, quantity: 1))
        }
    }

    func remove(atOffsets offsets: IndexSet) {
        self.lines.remove(atOffsets: offsets)
    }

    func clear() {
        self.lines.removeAll()
    }
}
