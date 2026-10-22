//
//  SearchModel.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import Foundation

/// Drives search and makes the tracking call for each step the way a customer integration should:
/// input focus → autocomplete select / search submit → search results loaded → search result click.
final class SearchModel: ObservableObject {

    @Published var query = "" {
        didSet { self.queryChanged() }
    }
    @Published private(set) var suggestions: [String] = []
    @Published private(set) var products: [Product] = []
    @Published private(set) var submittedTerm: String?
    @Published private(set) var resultID: String?
    @Published private(set) var totalResults = 0
    @Published private(set) var isLoading = false
    @Published private(set) var offlineReason: String?
    /// Bumped by reset() so the Shop tab can also pop back to its root
    @Published private(set) var resetCount = 0

    private let service: ConstructorService
    private var pendingAutocomplete: DispatchWorkItem?

    private var constructor: ConstructorIO {
        return self.service.constructor
    }

    init(service: ConstructorService) {
        self.service = service
    }

    // MARK: Journey steps

    func inputFocused() {
        self.constructor.trackInputFocus(searchTerm: self.trimmedQuery)
    }

    func selectSuggestion(_ suggestion: String) {
        let typed = self.trimmedQuery
        self.constructor.trackAutocompleteSelect(searchTerm: suggestion, originalQuery: typed, sectionName: DemoConfig.suggestionsSectionName)
        // Selecting a suggestion submits a search for it, so it's tracked as a submit too
        self.constructor.trackSearchSubmit(searchTerm: suggestion, originalQuery: typed)
        self.runSearch(suggestion)
    }

    // Popular searches are picked from an empty field, so the term doubles as the original query
    func selectPopularSearch(_ term: String) {
        self.constructor.trackAutocompleteSelect(searchTerm: term, originalQuery: term, sectionName: DemoConfig.suggestionsSectionName)
        self.constructor.trackSearchSubmit(searchTerm: term, originalQuery: term)
        self.runSearch(term)
    }

    func submit() {
        let term = self.trimmedQuery
        guard !term.isEmpty else { return }
        self.constructor.trackSearchSubmit(searchTerm: term, originalQuery: term)
        self.runSearch(term)
    }

    func resultTapped(_ product: Product) {
        self.constructor.trackSearchResultClick(itemName: product.name, customerID: product.customerID, variationID: product.variationID, searchTerm: self.submittedTerm, resultID: self.resultID)
    }

    /// Back to an empty search, as if the Shop tab was just opened. Responses still in flight are ignored.
    func reset() {
        self.pendingAutocomplete?.cancel()
        self.submittedTerm = nil
        self.query = ""
        self.suggestions = []
        self.products = []
        self.resultID = nil
        self.totalResults = 0
        self.isLoading = false
        self.offlineReason = nil
        self.resetCount += 1
    }

    // MARK: Requests

    private var trimmedQuery: String {
        return self.query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func queryChanged() {
        self.pendingAutocomplete?.cancel()
        let term = self.trimmedQuery
        guard !term.isEmpty, term != self.submittedTerm else {
            self.suggestions = []
            return
        }

        let work = DispatchWorkItem { [weak self] in self?.fetchSuggestions(for: term) }
        self.pendingAutocomplete = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: work)
    }

    private func fetchSuggestions(for term: String) {
        let query = CIOAutocompleteQuery(query: term, numResultsForSection: [DemoConfig.suggestionsSectionName: 5, "Products": 0])
        self.constructor.autocomplete(forQuery: query) { [weak self] response in
            // Ignore responses for text the user has since changed
            guard let self = self, self.trimmedQuery == term, term != self.submittedTerm else { return }
            if let sections = response.data?.sections {
                self.suggestions = sections[DemoConfig.suggestionsSectionName]?.map { $0.result.value } ?? []
            } else {
                self.suggestions = SampleCatalog.suggestions(for: term)
            }
        }
    }

    private func runSearch(_ term: String) {
        self.pendingAutocomplete?.cancel()
        self.submittedTerm = term
        self.query = term
        self.suggestions = []
        self.isLoading = true

        let query = CIOSearchQuery(query: term, perPage: DemoConfig.resultsPerPage)
        self.constructor.search(forQuery: query) { [weak self] response in
            guard let self = self, self.submittedTerm == term else { return }
            self.isLoading = false

            if let data = response.data {
                self.products = data.results.compactMap(Product.init(result:))
                self.resultID = data.resultID
                self.totalResults = data.totalNumResults
                self.offlineReason = nil
            } else {
                self.products = SampleCatalog.search(term)
                self.resultID = nil
                self.totalResults = self.products.count
                self.offlineReason = response.error?.demoDescription ?? "Unknown error"
            }

            self.constructor.trackSearchResultsLoaded(searchTerm: term, resultCount: self.totalResults, items: self.products.map { $0.cioItem }, resultID: self.resultID)
        }
    }
}

extension Error {
    var demoDescription: String {
        if let cioError = self as? CIOError {
            return [String(describing: cioError.errorType), cioError.errorMessage].compactMap { $0 }.joined(separator: ": ")
        }
        return self.localizedDescription
    }
}
