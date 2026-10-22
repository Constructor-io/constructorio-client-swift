//
//  FeaturedModel.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import Foundation

/// Loads the Home carousel. Fetching results isn't a tracking event, so nothing is recorded until a product is opened.
final class FeaturedModel: ObservableObject {

    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false

    private let service: ConstructorService

    init(service: ConstructorService) {
        self.service = service
    }

    func loadIfNeeded() {
        guard self.products.isEmpty, !self.isLoading else { return }
        self.isLoading = true

        let query = CIOSearchQuery(query: DemoConfig.featuredSearchTerm, perPage: DemoConfig.featuredCount)
        self.service.constructor.search(forQuery: query) { [weak self] response in
            guard let self = self else { return }
            self.isLoading = false
            let products = response.data?.results.compactMap(Product.init(result:)) ?? []
            self.products = products.isEmpty ? Array(SampleCatalog.products.prefix(DemoConfig.featuredCount)) : products
        }
    }
}
