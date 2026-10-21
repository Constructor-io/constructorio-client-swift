//
//  CIODebugOverlayViewController.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

/// Transparent root of the overlay window. Hosts the draggable debug button and presents the event log.
final class CIODebugOverlayViewController: UIViewController {

    private let button = CIODebugButton()
    private var hasPlacedButton = false

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .clear
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.button.addTarget(self, action: #selector(self.openEventLog), for: .touchUpInside)
        self.button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragButton(_:))))
        self.view.addSubview(self.button)

        NotificationCenter.default.addObserver(self, selector: #selector(self.logChanged), name: CIODebugEventLog.didChangeNotification, object: nil)
        self.logChanged()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.hasPlacedButton {
            self.hasPlacedButton = true
            let insets = self.view.safeAreaInsets
            // Bottom right, above where a tab bar usually sits
            self.button.center = CGPoint(x: self.view.bounds.maxX - insets.right - CIODebugButton.size / 2 - 16,
                                         y: self.view.bounds.maxY - insets.bottom - CIODebugButton.size / 2 - 72)
        } else {
            self.button.center = self.clamped(self.button.center)
        }
    }

    // Defer to the host app so the overlay never changes its orientation or status bar
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.hostViewController?.supportedInterfaceOrientations ?? .all
    }

    override var prefersStatusBarHidden: Bool {
        return self.hostViewController?.prefersStatusBarHidden ?? false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.hostViewController?.preferredStatusBarStyle ?? .default
    }

    private var hostViewController: UIViewController? {
        let hostWindow = UIApplication.shared.windows.first { !($0 is CIOPassthroughWindow) && $0.isKeyWindow }
        var top = hostWindow?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }

    @objc private func logChanged() {
        self.button.update(eventCount: CIODebugEventLog.shared.events.count, failureCount: CIODebugEventLog.shared.failureCount)
    }

    @objc private func openEventLog() {
        guard self.presentedViewController == nil else { return }
        let navigation = UINavigationController(rootViewController: CIODebugEventListViewController())
        self.present(navigation, animated: true)
    }

    @objc private func dragButton(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        self.button.center = CGPoint(x: self.button.center.x + translation.x, y: self.button.center.y + translation.y)
        gesture.setTranslation(.zero, in: self.view)

        if gesture.state == .ended || gesture.state == .cancelled {
            UIView.animate(withDuration: 0.2) {
                self.button.center = self.clamped(self.button.center)
            }
        }
    }

    private func clamped(_ point: CGPoint) -> CGPoint {
        let bounds = self.view.bounds.inset(by: self.view.safeAreaInsets).insetBy(dx: CIODebugButton.size / 2 + 8, dy: CIODebugButton.size / 2 + 8)
        guard !bounds.isNull, !bounds.isEmpty else { return point }
        return CGPoint(x: min(max(point.x, bounds.minX), bounds.maxX), y: min(max(point.y, bounds.minY), bounds.maxY))
    }
}

final class CIODebugButton: UIButton {

    static let size: CGFloat = 56

    private let badge = UILabel()
    private let iconView = UIImageView(image: CIODebugButtonImage.image)

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: CIODebugButton.size, height: CIODebugButton.size))
        // White so the dark outlines of the transparent icon stay visible
        self.backgroundColor = .white
        self.layer.cornerRadius = CIODebugButton.size / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 6
        self.layer.shadowOffset = CGSize(width: 0, height: 3)

        // Sized so the whole square fits inside the circle (38pt diagonal ≈ 54pt), so the artwork never needs clipping
        self.iconView.frame = self.bounds.insetBy(dx: 9, dy: 9)
        self.iconView.contentMode = .scaleAspectFit
        self.iconView.isUserInteractionEnabled = false
        self.addSubview(self.iconView)
        self.accessibilityIdentifier = "cio-debug-button"

        self.badge.font = .systemFont(ofSize: 11, weight: .bold)
        self.badge.textColor = .white
        self.badge.textAlignment = .center
        self.badge.layer.cornerRadius = 9
        self.badge.layer.masksToBounds = true
        self.badge.isHidden = true
        self.addSubview(self.badge)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(eventCount: Int, failureCount: Int) {
        self.badge.isHidden = eventCount == 0
        self.badge.text = eventCount > 99 ? "99+" : "\(eventCount)"
        self.badge.backgroundColor = failureCount > 0 ? CIODebugStyle.failure : CIODebugStyle.success
        let width = max(18, self.badge.intrinsicContentSize.width + 10)
        self.badge.frame = CGRect(x: CIODebugButton.size - width + 4, y: -4, width: width, height: 18)

        let failures = failureCount > 0 ? ", \(failureCount) failed" : ""
        self.accessibilityLabel = "Constructor debug, \(eventCount) events\(failures)"
    }
}
