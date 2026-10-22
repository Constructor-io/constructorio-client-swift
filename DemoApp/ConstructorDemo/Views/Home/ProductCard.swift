//
//  ProductCard.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import SwiftUI

/// A product tile for horizontal carousels.
struct ProductCard: View {

    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ProductImage(url: self.product.imageURL)
                .frame(width: 140, height: 140)
            Text(self.product.name)
                .font(.subheadline)
                .lineLimit(2, reservesSpace: true)
            Text(self.product.price.formattedPrice)
                .font(.subheadline.bold())
        }
        .frame(width: 140, alignment: .leading)
    }
}
