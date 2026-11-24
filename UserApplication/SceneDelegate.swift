//
//  SceneDelegate.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

// Creates the app window when the scene declared in Info.plist (UIApplicationSceneManifest) connects.
// iOS 12 and earlier have no scenes: there, AppDelegate creates the window when the app launches.
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // the app delegate builds the UI and keeps the window, the same way it does on iOS 12 and earlier
        appDelegate.showAutocompleteViewControllerAsRoot(in: window)
    }
}
