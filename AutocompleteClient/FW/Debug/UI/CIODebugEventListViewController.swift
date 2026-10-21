//
//  CIODebugEventListViewController.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

final class CIODebugEventListViewController: UITableViewController {

    private static let cellIdentifier = "CIODebugEventCell"

    private var events: [CIODebugEvent] = []

    init() {
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
        self.title = "Constructor Events"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.close))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(self.clear))
        self.tableView.register(CIODebugEventCell.self, forCellReuseIdentifier: CIODebugEventListViewController.cellIdentifier)

        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: CIODebugEventLog.didChangeNotification, object: nil)
        self.reload()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func reload() {
        self.events = CIODebugEventLog.shared.events
        self.navigationItem.rightBarButtonItem?.isEnabled = !self.events.isEmpty
        self.tableView.reloadData()
    }

    @objc private func close() {
        self.dismiss(animated: true)
    }

    @objc private func clear() {
        CIODebugEventLog.shared.clear()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(self.events.count, 1)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !self.events.isEmpty else { return nil }
        let failures = CIODebugEventLog.shared.failureCount
        return "\(self.events.count) events · \(failures) failed · newest first"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !self.events.isEmpty else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "No tracking events yet."
            cell.textLabel?.textColor = CIODebugStyle.secondaryText
            cell.selectionStyle = .none
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: CIODebugEventListViewController.cellIdentifier, for: indexPath)
        (cell as? CIODebugEventCell)?.configure(with: self.events[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !self.events.isEmpty else { return }
        self.navigationController?.pushViewController(CIODebugEventDetailViewController(event: self.events[indexPath.row]), animated: true)
    }
}

final class CIODebugEventCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.textLabel?.font = CIODebugStyle.monospaced(size: 16, weight: .medium)
        self.detailTextLabel?.textColor = CIODebugStyle.secondaryText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with event: CIODebugEvent) {
        self.imageView?.image = CIODebugStyle.statusImage(succeeded: event.succeeded)
        self.textLabel?.text = event.name.rawValue
        let failure = event.succeeded ? "" : " · \(event.statusDescription)"
        self.detailTextLabel?.text = "#\(event.sequence) · \(CIODebugStyle.timeFormatter.string(from: event.firedAt))\(failure)"
        self.detailTextLabel?.textColor = event.succeeded ? CIODebugStyle.secondaryText : CIODebugStyle.failure
        self.accessibilityIdentifier = "cio-debug-event-\(event.name.rawValue)"
    }
}
