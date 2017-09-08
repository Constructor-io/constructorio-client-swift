//
//  AutocompleteViewController+Show.swift
//  UserApplicationTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit
import ConstructorAutocomplete

extension CIOAutocompleteViewController {

    class func instantiate() -> CIOAutocompleteViewController {
        let viewController = CIOAutocompleteViewController(autocompleteKey: TestConstants.testAutocompleteKey)
        return viewController
    }

    func showInNewWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = self

        window.makeKeyAndVisible()
    }

}
