//
//  AutocompleteViewModel.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

public class AutocompleteViewModel: AbstractAutocompleteViewModel {

    public let handleResultQueue: OperationQueue

    public private(set) var searchTerm: String
    public var results: [AutocompleteViewModelSection]

    public var screenTitle: String
    public var modelSorter: (String, String) -> Bool = { return $0 < $1 }

    public weak var delegate: AutocompleteViewModelDelegate?

    public init() {
        self.results = []
        self.searchTerm = ""
        self.screenTitle = Constants.UI.defaultScreenTitle

        self.handleResultQueue = OperationQueue()

        self.handleResultQueue.maxConcurrentOperationCount = 1
    }

    public var lastResult: AutocompleteResult?

    internal func setupDataFromResult(result: AutocompleteResult) {
        self.searchTerm = result.query.query
        self.setResultFromDictionary(dictionary: result.response?.sections)
        self.lastResult = result

        self.delegate?.viewModel(self, didSetResult: result)
    }

    internal func setResultFromDictionary(dictionary: [String: [CIOAutocompleteResult]]?) {
        self.results = (dictionary ?? [:]).map { section, items in AutocompleteViewModelSection(items: items, sectionName: section) }
                                          .sorted { s1, s2 in self.modelSorter(s1.sectionName, s2.sectionName) }
    }

    public func set(searchResult: AutocompleteResult, completionHandler: @escaping () -> Void) {
        self.handleResultQueue.addOperation { [weak self] in
            guard let selfRef = self else {
                return
            }

            if let lastResult = selfRef.lastResult {
                if searchResult.isInitiatedAfter(result: lastResult) {
                    selfRef.setupDataFromResult(result: searchResult)
                } else {
                    selfRef.delegate?.viewModel(selfRef, didIgnoreResult: searchResult)
                }
            } else {
                // no previous result, this one must be valid
                self?.setupDataFromResult(result: searchResult)
            }

            DispatchQueue.main.async(execute: completionHandler)
        }
    }

    public func getResult(atIndexPath indexPath: IndexPath) -> CIOAutocompleteResult {
        return results[indexPath.section].items[indexPath.row]
    }

    public func getSectionName(atIndex index: Int) -> String {
        return results[index].sectionName
    }
}
