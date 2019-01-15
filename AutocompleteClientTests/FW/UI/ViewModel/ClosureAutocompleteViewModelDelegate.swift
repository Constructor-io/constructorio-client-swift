//
//  ClosureAutocompleteViewModelDelegate.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

public class ClosureAutocompleteViewModelDelegate: AutocompleteViewModelDelegate {

    public var onIgnoreResult: ((AutocompleteResult) -> Void)?
    public var onSetResult: ((AutocompleteResult) -> Void)?

    public init(viewModel: AutocompleteViewModel) {
        viewModel.delegate = self
    }

    public func viewModel(_ viewModel: AutocompleteViewModel, didSetResult result: AutocompleteResult) {
        self.onSetResult?(result)
    }

    public func viewModel(_ viewModel: AutocompleteViewModel, didIgnoreResult result: AutocompleteResult) {
        self.onIgnoreResult?(result)
    }

}
