//
//  AbstractAutocompleteViewModel+Mock.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

public class MockAutocompleteViewModel: AbstractAutocompleteViewModel {

    public private(set) var searchTerm: String
    public var results: [AutocompleteViewModelSection]

    public var screenTitle: String
    public var modelSorter: (String, String) -> Bool = { return $0 < $1 }

    public weak var delegate: AutocompleteViewModelDelegate?

    public init() {
        self.results = []
        self.searchTerm = ""
        self.screenTitle = "title"
    }

    public var lastResult: AutocompleteResult?

    internal func setupDataFromResult(result: AutocompleteResult) {
        self.searchTerm = result.query.query
        self.setResultFromDictionary(dictionary: result.response?.sections)
        self.lastResult = result

        self.delegate?.viewModel(self, didSetResult: result)
    }

    internal func setResultFromDictionary(dictionary: [String: [CIOResult]]?) {
        self.results = (dictionary ?? [:]).map { (section, items) in AutocompleteViewModelSection(items: items, sectionName: section) }
            .sorted { (s1, s2) in self.modelSorter(s1.sectionName, s2.sectionName) }
    }

    public func set(searchResult: AutocompleteResult, completionHandler: @escaping () -> Void) {
        if let lastResult = self.lastResult {
            if searchResult.isInitiatedAfter(result: lastResult) {
                self.setupDataFromResult(result: searchResult)
            } else {
                self.delegate?.viewModel(self, didIgnoreResult: searchResult)
            }
        } else {
            // no previous result, this one must be valid
            self.setupDataFromResult(result: searchResult)
        }

        DispatchQueue.main.async(execute: completionHandler)
    }

    public func getResult(atIndexPath indexPath: IndexPath) -> CIOResult {
        return results[indexPath.section].items[indexPath.row]
    }

    public func getSectionName(atIndex index: Int) -> String {
        return results[index].sectionName
    }
}
