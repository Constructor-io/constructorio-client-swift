//
//  CIOJourneyTooltipView.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

/// Bubble next to the debug button that walks the developer through the journey being recorded
final class CIOJourneyTooltipView: UIView {

    enum ArrowEdge {
        case top
        case bottom
    }

    static let arrowSize = CGSize(width: 16, height: 8)

    var onDismiss: (() -> Void)?

    /// Where the arrow points, in this view's coordinates
    var arrowX: CGFloat = 0 {
        didSet { self.setNeedsLayout() }
    }

    var arrowEdge: ArrowEdge = .bottom {
        didSet { self.setNeedsLayout() }
    }

    private let bubble = UIView()
    private let arrow = CAShapeLayer()
    private let stack = UIStackView()
    private let stepLabel = UILabel()
    private let instructionLabel = UILabel()
    private let eventLabel = UILabel()
    private let lastResultLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.accessibilityIdentifier = "cio-journey-tooltip"

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)

        self.arrow.fillColor = CIODebugStyle.brand.cgColor
        self.layer.addSublayer(self.arrow)

        self.bubble.backgroundColor = CIODebugStyle.brand
        self.bubble.layer.cornerRadius = 12
        self.addSubview(self.bubble)

        self.stepLabel.font = .systemFont(ofSize: 11, weight: .bold)
        self.stepLabel.textColor = UIColor.white.withAlphaComponent(0.7)

        self.instructionLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        self.instructionLabel.textColor = .white
        self.instructionLabel.numberOfLines = 0

        self.eventLabel.font = CIODebugStyle.monospaced(size: 12, weight: .medium)
        self.eventLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        self.eventLabel.numberOfLines = 0

        self.lastResultLabel.font = .systemFont(ofSize: 12, weight: .medium)
        self.lastResultLabel.numberOfLines = 0

        self.stack.axis = .vertical
        self.stack.spacing = 4
        self.stack.addArrangedSubview(self.stepLabel)
        self.stack.addArrangedSubview(self.instructionLabel)
        self.stack.addArrangedSubview(self.eventLabel)
        self.stack.addArrangedSubview(self.lastResultLabel)
        self.stack.setCustomSpacing(8, after: self.eventLabel)
        self.bubble.addSubview(self.stack)

        self.closeButton.setTitle("✕", for: .normal)
        self.closeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        self.closeButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        self.closeButton.accessibilityLabel = "Dismiss journey tips"
        self.closeButton.accessibilityIdentifier = "cio-journey-tooltip-close"
        self.closeButton.addTarget(self, action: #selector(self.dismissTapped), for: .touchUpInside)
        self.bubble.addSubview(self.closeButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(step: String, instruction: String, event: String?, lastResult: (text: String, color: UIColor)?) {
        self.stepLabel.text = step.uppercased()
        self.instructionLabel.text = instruction
        self.eventLabel.text = event.map { $0.contains(",") ? "Expected events: \($0)" : "Expected event: \($0)" }
        self.eventLabel.isHidden = event == nil
        self.lastResultLabel.text = lastResult?.text
        self.lastResultLabel.textColor = lastResult?.color
        self.lastResultLabel.isHidden = lastResult == nil
        self.accessibilityLabel = [step, instruction, event.map { "expected event \($0)" }, lastResult?.text].compactMap { $0 }.joined(separator: ". ")
        self.setNeedsLayout()
    }

    /// The size the tooltip needs, arrow included, at a given width
    func fittingSize(width: CGFloat) -> CGSize {
        let textWidth = width - Self.padding * 2 - Self.closeWidth
        let textHeight = self.stack.systemLayoutSizeFitting(CGSize(width: textWidth, height: UIView.layoutFittingCompressedSize.height),
                                                           withHorizontalFittingPriority: .required,
                                                           verticalFittingPriority: .fittingSizeLevel).height
        return CGSize(width: width, height: textHeight + Self.padding * 2 + Self.arrowSize.height)
    }

    private static let padding: CGFloat = 12
    private static let closeWidth: CGFloat = 24

    override func layoutSubviews() {
        super.layoutSubviews()
        let arrowHeight = Self.arrowSize.height
        let bubbleFrame = self.arrowEdge == .bottom
            ? CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - arrowHeight)
            : CGRect(x: 0, y: arrowHeight, width: self.bounds.width, height: self.bounds.height - arrowHeight)
        self.bubble.frame = bubbleFrame
        self.stack.frame = CGRect(x: Self.padding, y: Self.padding,
                                  width: bubbleFrame.width - Self.padding * 2 - Self.closeWidth,
                                  height: bubbleFrame.height - Self.padding * 2)
        self.closeButton.frame = CGRect(x: bubbleFrame.width - Self.closeWidth - 6, y: 4, width: Self.closeWidth + 4, height: Self.closeWidth + 4)

        // Keep the arrow on the bubble's straight edge, clear of the rounded corners
        let half = Self.arrowSize.width / 2
        let x = min(max(self.arrowX, 14 + half), self.bounds.width - 14 - half)
        let path = UIBezierPath()
        if self.arrowEdge == .bottom {
            path.move(to: CGPoint(x: x - half, y: bubbleFrame.maxY))
            path.addLine(to: CGPoint(x: x, y: self.bounds.height))
            path.addLine(to: CGPoint(x: x + half, y: bubbleFrame.maxY))
        } else {
            path.move(to: CGPoint(x: x - half, y: arrowHeight))
            path.addLine(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x + half, y: arrowHeight))
        }
        path.close()
        self.arrow.path = path.cgPath
    }

    @objc private func dismissTapped() {
        self.onDismiss?()
    }
}
