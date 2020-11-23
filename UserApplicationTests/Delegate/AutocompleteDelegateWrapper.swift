//
//  AutocompleteDelegateWrapper.swift
//  UserApplicationTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

class AutocompleteDelegateWrapper: CIOAutocompleteDelegate {

    var onSelect: ((_ result: CIOAutocompleteResult) -> Void)?
    var onSearchPerformed: ((_ searchTerm: String) -> Void)?
    var onLoad: (() -> Void)?
    var onWillAppear: (() -> Void)?

    func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOAutocompleteResult) {
        self.onSelect?(result)
    }

    func autocompleteController(controller: CIOAutocompleteViewController, didPerformSearch searchTerm: String) {
        self.onSearchPerformed?(searchTerm)
    }

    func autocompleteControllerWillAppear(controller: CIOAutocompleteViewController) {
        self.onWillAppear?()
    }

    func autocompleteControllerDidLoad(controller: CIOAutocompleteViewController) {
        self.onLoad?()
    }

}
