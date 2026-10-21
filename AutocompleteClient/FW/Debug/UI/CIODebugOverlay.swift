//
//  CIODebugOverlay.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

/// Floating debug button shown above the host app while debug mode is on. Lives in its own window so the host app's
/// view hierarchy is never touched, and passes every touch outside the button through to the host app.
final class CIODebugOverlay {

    static let shared = CIODebugOverlay()

    private var window: CIOPassthroughWindow?

    var isVisible: Bool {
        return self.window != nil
    }

    func show() {
        guard self.window == nil else { return }
        guard let window = CIOPassthroughWindow.make() else {
            // No active scene yet (e.g. called during launch). Try again once the app is active.
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
            return
        }

        let root = CIODebugOverlayViewController()
        window.rootViewController = root
        window.windowLevel = UIWindow.Level.alert + 1
        window.isHidden = false
        self.window = window
    }

    func hide() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        self.window?.isHidden = true
        self.window = nil
    }

    @objc private func applicationDidBecomeActive() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        self.show()
    }
}

final class CIOPassthroughWindow: UIWindow {

    static func make() -> CIOPassthroughWindow? {
        if #available(iOS 13.0, *) {
            if let scene = self.hostScene() {
                return CIOPassthroughWindow(windowScene: scene)
            }
            // A scene-based app must attach windows to a scene, so wait until one connects
            if UIApplication.shared.supportsMultipleScenes || Bundle.main.object(forInfoDictionaryKey: "UIApplicationSceneManifest") != nil {
                return nil
            }
        }
        // Apps without a scene manifest: UIKit attaches frame-based windows to the app's implicit scene
        return CIOPassthroughWindow(frame: UIScreen.main.bounds)
    }

    @available(iOS 13.0, *)
    private static func hostScene() -> UIWindowScene? {
        // Prefer the scene the app's own window lives in
        if let scene = UIApplication.shared.windows.first(where: { !($0 is CIOPassthroughWindow) && $0.windowScene != nil })?.windowScene {
            return scene
        }
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        return scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first
    }

    // Only claim touches that land on the overlay's own controls or a presented debug screen
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hit = super.hitTest(point, with: event) else { return nil }
        if hit === self || hit === self.rootViewController?.view {
            return nil
        }
        return hit
    }
}
