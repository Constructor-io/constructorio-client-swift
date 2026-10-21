//
//  CIODebugStyle.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

enum CIODebugStyle {

    static let brand = UIColor(red: 0.16, green: 0.15, blue: 0.33, alpha: 1)
    static let success = UIColor(red: 0.20, green: 0.66, blue: 0.33, alpha: 1)
    static let failure = UIColor(red: 0.86, green: 0.24, blue: 0.20, alpha: 1)

    static var secondaryText: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        }
        return .gray
    }

    static func monospaced(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        if #available(iOS 13.0, *) {
            return .monospacedSystemFont(ofSize: size, weight: weight)
        }
        return UIFont(name: "Menlo", size: size) ?? .systemFont(ofSize: size, weight: weight)
    }

    static func statusImage(succeeded: Bool) -> UIImage? {
        if #available(iOS 13.0, *) {
            let name = succeeded ? "checkmark.circle.fill" : "exclamationmark.triangle.fill"
            return UIImage(systemName: name)?.withTintColor(succeeded ? self.success : self.failure, renderingMode: .alwaysOriginal)
        }
        return nil
    }

    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
