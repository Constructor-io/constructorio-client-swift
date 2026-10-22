//
//  CIODebugOverlayViewController.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

/// Transparent root of the overlay window. Hosts the draggable debug button and presents the debug screen.
final class CIODebugOverlayViewController: UIViewController {

    private let button = CIODebugButton()
    private let tooltip = CIOJourneyTooltipView()
    private var hasPlacedButton = false

    // Dismissing the tooltip hides it for the rest of that recording
    private var tooltipDismissedFor: Date?

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .clear
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.button.addTarget(self, action: #selector(self.openDebugScreen), for: .touchUpInside)
        self.button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragButton(_:))))
        self.view.addSubview(self.button)

        self.tooltip.isHidden = true
        self.tooltip.onDismiss = { [weak self] in
            self?.tooltipDismissedFor = CIOJourneySession.shared.startedAt
            self?.updateTooltip()
        }
        self.view.addSubview(self.tooltip)

        NotificationCenter.default.addObserver(self, selector: #selector(self.logChanged), name: CIODebugEventLog.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.logChanged), name: CIOJourneySession.didChangeNotification, object: nil)
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
        self.layoutTooltip()
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
        let session = CIOJourneySession.shared
        if session.isRecording, let report = session.report {
            self.button.updateRecording(progress: "\(report.completedStepCount)/\(report.steps.count)")
        } else {
            self.button.updateRecording(progress: nil)
        }
        self.updateTooltip()
    }

    // MARK: Journey tooltip

    private func updateTooltip() {
        let session = CIOJourneySession.shared
        guard session.isRecording, let report = session.report, self.tooltipDismissedFor != session.startedAt else {
            self.setTooltipHidden(true)
            return
        }

        let lastResult = self.lastEventResult(in: report)
        let next = report.nextSteps
        if next.count > 1 {
            // Steps that can fire in either order
            let numbers = next.map { "\($0.index + 1)" }.joined(separator: " & ")
            self.tooltip.configure(step: "Steps \(numbers) of \(report.steps.count), any order",
                                   instruction: next.map { $0.step.instruction }.joined(separator: "\n"),
                                   event: next.map { $0.step.event }.joined(separator: ", "),
                                   lastResult: lastResult)
        } else if let next = next.first {
            self.tooltip.configure(step: "Step \(next.index + 1) of \(report.steps.count)",
                                   instruction: next.step.instruction,
                                   event: next.step.event,
                                   lastResult: lastResult)
        } else {
            self.tooltip.configure(step: "All \(report.steps.count) steps fired",
                                   instruction: "Tap the debug button and Stop to see the results.",
                                   event: nil,
                                   lastResult: lastResult)
        }
        self.setTooltipHidden(false)
        self.layoutTooltip()
    }

    /// How the most recent journey event went, so the developer gets feedback without opening the debug screen
    private func lastEventResult(in report: CIOJourneyReport) -> (text: String, color: UIColor)? {
        let good = UIColor(red: 0.55, green: 0.9, blue: 0.6, alpha: 1)
        let warn = UIColor(red: 1, green: 0.8, blue: 0.4, alpha: 1)
        let bad = UIColor(red: 1, green: 0.55, blue: 0.5, alpha: 1)

        let accepted = report.steps.filter { $0.order == .inOrder }.compactMap { result in result.event.map { (result, $0) } }
        let lastAccepted = accepted.max { $0.1.firedAt < $1.1.firedAt }
        let lastExtra = report.extraEvents.filter { extra in
            if case .unexpected = extra.kind { return false }
            return true
        }.max { $0.event.firedAt < $1.event.firedAt }

        // A rejected event that fired after the last accepted one is the most recent news
        if let extra = lastExtra, extra.event.firedAt > (lastAccepted?.1.firedAt ?? .distantPast) {
            switch extra.kind {
            case .outOfOrder(let stepIndex, _):
                return ("✗ \(extra.event.name.rawValue) fired out of order. It's step \(stepIndex + 1), not accepted yet.", bad)
            case .duplicate:
                return ("! \(extra.event.name.rawValue) fired again (duplicate)", warn)
            case .unexpected:
                break
            }
        }

        guard let (last, _) = lastAccepted else { return nil }
        switch last.status {
        case .passed:
            return ("✓ \(last.step.event): \(last.statusDescription)", good)
        case .warning:
            return ("! \(last.step.event): \(last.statusDescription)", warn)
        default:
            return ("✗ \(last.step.event): \(last.statusDescription)", bad)
        }
    }

    private func setTooltipHidden(_ hidden: Bool) {
        guard self.tooltip.isHidden != hidden else { return }
        if hidden {
            UIView.animate(withDuration: 0.15, animations: { self.tooltip.alpha = 0 }, completion: { _ in
                self.tooltip.isHidden = true
            })
        } else {
            self.tooltip.alpha = 0
            self.tooltip.isHidden = false
            UIView.animate(withDuration: 0.2) { self.tooltip.alpha = 1 }
        }
    }

    // Above the button when there's room, otherwise below, with the arrow pointing at the button
    private func layoutTooltip() {
        guard !self.tooltip.isHidden else { return }
        let safe = self.view.bounds.inset(by: self.view.safeAreaInsets).insetBy(dx: 12, dy: 8)
        let width = min(300, safe.width)
        let size = self.tooltip.fittingSize(width: width)
        let buttonFrame = self.button.frame.insetBy(dx: -6, dy: -6)

        let above = buttonFrame.minY - size.height >= safe.minY
        let y = above ? buttonFrame.minY - size.height : buttonFrame.maxY
        let x = min(max(self.button.center.x - width / 2, safe.minX), safe.maxX - width)

        self.tooltip.arrowEdge = above ? .bottom : .top
        self.tooltip.frame = CGRect(x: x, y: y, width: width, height: size.height)
        self.tooltip.arrowX = self.button.center.x - x
    }

    @objc private func openDebugScreen() {
        guard self.presentedViewController == nil else { return }
        // Go straight back to the journey while one is recording, so Stop is one tap away
        let session = CIOJourneySession.shared
        let tabs = CIODebugTabBarController(selectedTab: session.isRecording ? .journeys : .events)
        if session.isRecording, let journey = session.journey, let journeys = tabs.viewControllers?[CIODebugTabBarController.Tab.journeys.rawValue] as? UINavigationController {
            journeys.pushViewController(CIOJourneyRunViewController(journey: journey), animated: false)
        }
        self.present(tabs, animated: true)
    }

    @objc private func dragButton(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        self.button.center = CGPoint(x: self.button.center.x + translation.x, y: self.button.center.y + translation.y)
        gesture.setTranslation(.zero, in: self.view)
        self.layoutTooltip()

        if gesture.state == .ended || gesture.state == .cancelled {
            UIView.animate(withDuration: 0.2) {
                self.button.center = self.clamped(self.button.center)
                self.layoutTooltip()
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
    private let recordingRing = CAShapeLayer()
    private let progressLabel = UILabel()
    private var eventsAccessibilityLabel = ""
    private var recordingProgress: String?
    private var isRecording: Bool {
        return self.recordingProgress != nil
    }

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

        self.recordingRing.path = UIBezierPath(ovalIn: self.bounds.insetBy(dx: -3, dy: -3)).cgPath
        self.recordingRing.fillColor = UIColor.clear.cgColor
        self.recordingRing.strokeColor = CIODebugStyle.failure.cgColor
        self.recordingRing.lineWidth = 3
        self.recordingRing.isHidden = true
        self.layer.addSublayer(self.recordingRing)

        self.progressLabel.font = .systemFont(ofSize: 11, weight: .bold)
        self.progressLabel.textColor = .white
        self.progressLabel.backgroundColor = CIODebugStyle.failure
        self.progressLabel.textAlignment = .center
        self.progressLabel.layer.cornerRadius = 9
        self.progressLabel.layer.masksToBounds = true
        self.progressLabel.isHidden = true
        self.addSubview(self.progressLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(eventCount: Int, failureCount: Int) {
        self.badge.isHidden = eventCount == 0
        self.badge.text = eventCount > 99 ? "99+" : "\(eventCount)"
        self.badge.backgroundColor = failureCount > 0 ? CIODebugStyle.failure : CIODebugStyle.success
        self.layoutBadge()

        let failures = failureCount > 0 ? ", \(failureCount) failed" : ""
        self.eventsAccessibilityLabel = "Constructor debug, \(eventCount) events\(failures)"
        self.updateAccessibilityLabel()
    }

    /// Shows a red ring and the journey progress while recording; nil hides them
    func updateRecording(progress: String?) {
        self.recordingProgress = progress
        self.recordingRing.isHidden = progress == nil
        self.progressLabel.isHidden = progress == nil
        self.progressLabel.text = progress
        let width = max(30, self.progressLabel.intrinsicContentSize.width + 10)
        // Below the ring rather than on it
        self.progressLabel.frame = CGRect(x: (CIODebugButton.size - width) / 2, y: CIODebugButton.size - 4, width: width, height: 18)
        self.layoutBadge()
        self.updateAccessibilityLabel()
    }

    // The ring is 3pt outside the button, so while recording the badge sits further out, on the top left, clear of it
    private func layoutBadge() {
        let width = max(18, self.badge.intrinsicContentSize.width + 10)
        if self.isRecording {
            self.badge.frame = CGRect(x: -10, y: -10, width: width, height: 18)
        } else {
            self.badge.frame = CGRect(x: CIODebugButton.size - width + 4, y: -4, width: width, height: 18)
        }
        // Drawn above the ring layer
        self.bringSubviewToFront(self.badge)
        self.badge.layer.zPosition = 1
        self.progressLabel.layer.zPosition = 1
    }

    private func updateAccessibilityLabel() {
        let recording = self.recordingProgress.map { ", recording journey, \($0) steps" } ?? ""
        self.accessibilityLabel = self.eventsAccessibilityLabel + recording
    }
}
