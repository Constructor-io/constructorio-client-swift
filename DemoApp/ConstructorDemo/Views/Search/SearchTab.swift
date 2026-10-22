//
//  SearchTab.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import SwiftUI

struct SearchTab: View {

    @EnvironmentObject private var model: SearchModel
    @State private var path: [Product] = []
    @FocusState private var searchFocused: Bool

    var body: some View {
        NavigationStack(path: self.$path) {
            List {
                if !self.model.suggestions.isEmpty {
                    self.suggestionsSection
                } else if self.searchFocused && self.model.query.isEmpty {
                    self.popularSection
                } else if self.model.submittedTerm != nil {
                    if let reason = self.model.offlineReason {
                        self.offlineSection(reason: reason)
                    }
                    self.resultsSection
                } else {
                    self.hintSection
                }
            }
            .listStyle(.insetGrouped)
            .safeAreaInset(edge: .top) { self.searchField }
            .navigationTitle("Shop")
            .homeLogo()
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product, searchTerm: self.model.submittedTerm)
            }
            .onChange(of: self.searchFocused) { focused in
                if focused { self.model.inputFocused() }
            }
            .onChange(of: self.model.resetCount) { _ in
                self.searchFocused = false
                self.path = []
            }
        }
    }

    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Search products", text: self.$model.query)
                .focused(self.$searchFocused)
                .submitLabel(.search)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onSubmit { self.model.submit() }
            if !self.model.query.isEmpty {
                Button {
                    self.model.query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(10)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .padding(.bottom, 6)
        .background(Color(.systemGroupedBackground))
    }

    private var popularSection: some View {
        Section("Popular searches") {
            ForEach(DemoConfig.popularSearches, id: \.self) { term in
                Button {
                    self.searchFocused = false
                    self.model.selectPopularSearch(term)
                } label: {
                    Label(term.capitalized, systemImage: "arrow.up.right")
                }
                .foregroundStyle(.primary)
                .accessibilityIdentifier("popular-search")
            }
        }
    }

    private var suggestionsSection: some View {
        Section("Suggestions") {
            ForEach(self.model.suggestions, id: \.self) { suggestion in
                Button {
                    self.searchFocused = false
                    self.model.selectSuggestion(suggestion)
                } label: {
                    Label(suggestion, systemImage: "arrow.up.left")
                }
                .foregroundStyle(.primary)
            }
        }
    }

    private func offlineSection(reason: String) -> some View {
        Section {
            Label("Can\u{2019}t reach the store right now. Showing sample products.", systemImage: "wifi.exclamationmark")
                .font(.footnote)
                .foregroundStyle(.orange)
        } footer: {
            Text(reason)
        }
    }

    @ViewBuilder
    private var resultsSection: some View {
        if self.model.isLoading {
            Section { ProgressView().frame(maxWidth: .infinity) }
        } else if self.model.products.isEmpty {
            Section { Text("No results for \u{201C}\(self.model.submittedTerm ?? "")\u{201D}").foregroundStyle(.secondary) }
        } else {
            Section("\(self.model.totalResults) results for \u{201C}\(self.model.submittedTerm ?? "")\u{201D}") {
                ForEach(self.model.products) { product in
                    Button {
                        self.model.resultTapped(product)
                        self.path.append(product)
                    } label: {
                        ProductRow(product: product)
                    }
                    .foregroundStyle(.primary)
                    .accessibilityIdentifier("search-result")
                }
            }
        }
    }

    private var hintSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("What are you looking for?").font(.headline)
                Text("Try \u{201C}apple\u{201D}, \u{201C}milk\u{201D} or \u{201C}bread\u{201D}.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
}
