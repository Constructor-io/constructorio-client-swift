//
//  ProductRow.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import SwiftUI

struct ProductRow: View {

    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            ProductImage(url: self.product.imageURL)
                .frame(width: 56, height: 56)
            VStack(alignment: .leading, spacing: 2) {
                Text(self.product.name).lineLimit(2)
                Text(self.product.price.formattedPrice)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
    }
}

struct ProductImage: View {

    let url: URL?

    var body: some View {
        AsyncImage(url: self.url) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            Image(systemName: "bag")
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
