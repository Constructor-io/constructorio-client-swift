//
//  CIODebugEventDetailViewController.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

final class CIODebugEventDetailViewController: UITableViewController {

    private struct Row {
        let title: String
        let value: String
        var isFailure = false
    }

    private struct Section {
        let title: String
        let rows: [Row]
    }

    private let event: CIODebugEvent
    private var sections: [Section] = []

    init(event: CIODebugEvent) {
        self.event = event
        if #available(iOS 13.0, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(style: .grouped)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.event.name.rawValue
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.share(_:)))
        self.sections = self.buildSections()
    }

    private func buildSections() -> [Section] {
        var sections = [
            Section(title: "Event", rows: [
                Row(title: "Name", value: self.event.name.rawValue),
                Row(title: "Sequence", value: "#\(self.event.sequence)"),
                Row(title: "Fired at", value: CIODebugStyle.timeFormatter.string(from: self.event.firedAt)),
                Row(title: "Status", value: self.event.statusDescription, isFailure: !self.event.succeeded)
            ]),
            Section(title: "Request", rows: [
                Row(title: "Method", value: self.event.httpMethod),
                Row(title: "URL", value: self.event.url?.absoluteString ?? "—")
            ])
        ]

        if !self.event.succeeded {
            var rows: [Row] = []
            if let statusCode = self.event.statusCode {
                rows.append(Row(title: "Status code", value: "\(statusCode) \(HTTPURLResponse.localizedString(forStatusCode: statusCode).capitalized)", isFailure: true))
            }
            if let errorMessage = self.event.errorMessage {
                rows.append(Row(title: "Error message", value: errorMessage, isFailure: true))
            }
            if let responseBody = self.event.responseBody {
                rows.append(Row(title: "Body", value: CIODebugEventDetailViewController.prettyJSON(responseBody)))
            }
            // Right below the event summary, since this is what you open a failed event for
            sections.insert(Section(title: "Response", rows: rows), at: 1)
        }

        if !self.event.queryItems.isEmpty {
            sections.append(Section(title: "Query parameters", rows: self.event.queryItems.map { Row(title: $0.name, value: $0.value ?? "") }))
        }

        if let body = self.event.body {
            sections.append(Section(title: "Request Body", rows: [Row(title: "", value: CIODebugEventDetailViewController.prettyJSON(body))]))
        }

        return sections
    }

    @objc private func share(_ sender: UIBarButtonItem) {
        let activity = UIActivityViewController(activityItems: [self.event.description], applicationActivities: nil)
        activity.popoverPresentationController?.barButtonItem = sender
        self.present(activity, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.sections[indexPath.section].rows[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.text = row.title.isEmpty ? nil : row.title
        cell.textLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        cell.textLabel?.textColor = CIODebugStyle.secondaryText
        cell.detailTextLabel?.text = row.value
        cell.detailTextLabel?.font = CIODebugStyle.monospaced(size: 14)
        cell.detailTextLabel?.numberOfLines = 0
        if row.isFailure {
            cell.detailTextLabel?.textColor = CIODebugStyle.failure
        }
        return cell
    }

    // Long-press to copy a single value
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy(_:))
    }

    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        UIPasteboard.general.string = self.sections[indexPath.section].rows[indexPath.row].value
    }

    private static func prettyJSON(_ string: String) -> String {
        guard let data = string.data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: data),
              let pretty = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]),
              let result = String(data: pretty, encoding: .utf8) else {
            return string
        }
        return result
    }
}
