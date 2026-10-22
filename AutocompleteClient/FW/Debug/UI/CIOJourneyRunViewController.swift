//
//  CIOJourneyRunViewController.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

/// One journey: its steps and a Record button before recording, the live checklist while recording, and the results once stopped
final class CIOJourneyRunViewController: UITableViewController {

    private enum Section {
        case summary
        case steps
        case extras
    }

    private enum Mode {
        /// Not recording this journey: show its steps, with Record in the navigation bar
        case ready
        case recording
        case finished
    }

    private let journey: CIOJourney
    private var mode: Mode = .ready
    private var report: CIOJourneyReport?
    private var sections: [Section] = []

    init(journey: CIOJourney) {
        self.journey = journey
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: CIOJourneySession.didChangeNotification, object: nil)
        self.reload()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func reload() {
        let session = CIOJourneySession.shared
        self.title = self.journey.name

        // The session only describes this screen when it holds this journey
        if session.journey?.id == self.journey.id, let report = session.report {
            self.mode = session.isRecording ? .recording : .finished
            self.report = report
        } else {
            self.mode = .ready
            self.report = CIOJourneyValidator.validate(journey: self.journey, events: [], isFinal: false)
        }

        switch self.mode {
        case .ready:
            self.navigationItem.rightBarButtonItems = [self.recordButton(title: "Record")]
            self.sections = [.steps]
        case .recording:
            let stop = UIBarButtonItem(title: "Stop", style: .done, target: self, action: #selector(self.stop))
            stop.tintColor = CIODebugStyle.failure
            stop.accessibilityIdentifier = "cio-journey-stop"
            self.navigationItem.rightBarButtonItems = [stop]
            self.sections = [.summary, .steps]
        case .finished:
            let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.share(_:)))
            // Rightmost first
            self.navigationItem.rightBarButtonItems = [self.recordButton(title: "Record again"), share]
            self.sections = [.summary, .steps]
        }
        if self.mode != .ready, !(self.report?.extraEvents.isEmpty ?? true) {
            self.sections.append(.extras)
        }
        self.tableView.reloadData()
    }

    private func recordButton(title: String) -> UIBarButtonItem {
        let item = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(self.recordTapped))
        item.tintColor = CIODebugStyle.failure
        item.accessibilityIdentifier = "cio-journey-record"
        return item
    }

    private func record() {
        let session = CIOJourneySession.shared
        guard session.isRecording, let current = session.journey, current.id != self.journey.id else {
            self.startRecording()
            return
        }
        let alert = UIAlertController(title: "Stop recording \(current.name)?", message: "Recording \(self.journey.name) discards the current recording.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Record", style: .destructive) { _ in
            self.startRecording()
        })
        self.present(alert, animated: true)
    }

    // Close the debug screen so the app is ready to use; the tooltip on the debug button takes over from here
    private func startRecording() {
        CIOJourneySession.shared.start(self.journey)
        (self.tabBarController ?? self.navigationController ?? self).dismiss(animated: true)
    }

    @objc private func stop() {
        CIOJourneySession.shared.stop()
    }


    @objc private func share(_ sender: UIBarButtonItem) {
        guard let report = self.report else { return }
        let activity = UIActivityViewController(activityItems: [report.description], applicationActivities: nil)
        activity.popoverPresentationController?.barButtonItem = sender
        self.present(activity, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.sections[section] {
        case .summary:
            return nil
        case .steps:
            return "Steps, in the expected order"
        case .extras:
            return "Other events"
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch self.sections[section] {
        case .summary:
            return self.mode == .recording ? "Use the app as the steps describe, then come back with the debug button and tap Stop." : nil
        case .steps:
            return self.mode == .ready ? "Tap Record, then use the app as the steps describe. Events must fire in this order." : "Tap a step to see every parameter check."
        case .extras:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let report = self.report else { return 0 }
        switch self.sections[section] {
        case .summary:
            return 1
        case .steps:
            return report.steps.count
        case .extras:
            return report.extraEvents.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.detailTextLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        guard let report = self.report else { return cell }

        switch self.sections[indexPath.section] {

        case .summary:
            cell.imageView?.image = CIOJourneyStyle.verdictImage(report.verdict)
            cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            if report.isFinal {
                cell.textLabel?.text = report.verdictDescription
                cell.textLabel?.textColor = CIOJourneyStyle.verdictColor(report.verdict)
            } else {
                cell.textLabel?.text = "Recording · \(report.completedStepCount)/\(report.steps.count)"
            }
            cell.detailTextLabel?.text = report.summary
            cell.detailTextLabel?.textColor = CIODebugStyle.secondaryText
            cell.accessibilityIdentifier = "cio-journey-verdict"

        case .steps:
            let result = report.steps[indexPath.row]
            cell.imageView?.image = CIOJourneyStyle.statusImage(result.status)
            cell.textLabel?.text = "\(result.index + 1). \(result.step.event)"
            cell.textLabel?.font = CIODebugStyle.monospaced(size: 15, weight: .medium)
            let sequence = result.event.map { " · #\($0.sequence)" } ?? ""
            // Steps sharing an order can fire either way round
            let orders = CIOJourneyValidator.orders(of: report.journey)
            let siblings = report.steps.filter { $0.index != result.index && orders[$0.index] == orders[result.index] }
            let anyOrder = siblings.isEmpty ? "" : "\nAny order with step \(siblings.map { "\($0.index + 1)" }.joined(separator: ", "))"
            if self.mode == .ready {
                cell.imageView?.image = CIODebugStyle.tinted("circle", CIODebugStyle.secondaryText)
                cell.detailTextLabel?.text = result.step.instruction + anyOrder
            } else {
                let instruction = result.status == .pending ? "\n\(result.step.instruction)" : ""
                cell.detailTextLabel?.text = "\(result.statusDescription)\(sequence)\(instruction)\(anyOrder)"
            }
            cell.detailTextLabel?.textColor = CIOJourneyStyle.statusColor(result.status)
            if result.event != nil {
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            }
            cell.accessibilityIdentifier = "cio-journey-step-\(result.step.id)"

        case .extras:
            let extra = report.extraEvents[indexPath.row]
            cell.textLabel?.text = extra.event.name.rawValue
            cell.textLabel?.font = CIODebugStyle.monospaced(size: 15, weight: .medium)
            switch extra.kind {
            case .duplicate(let stepIndex):
                cell.imageView?.image = CIODebugStyle.tinted("doc.on.doc.fill", CIODebugStyle.warning)
                cell.detailTextLabel?.text = "Duplicate of step \(stepIndex + 1) · #\(extra.event.sequence)"
            case .outOfOrder(let stepIndex, let expectedStepIndex):
                cell.imageView?.image = CIOJourneyStyle.statusImage(.outOfOrder)
                cell.detailTextLabel?.text = "Out of order · step \(stepIndex + 1), fired while step \(expectedStepIndex + 1) (\(report.journey.steps[expectedStepIndex].event)) was expected · #\(extra.event.sequence)"
                cell.detailTextLabel?.textColor = CIODebugStyle.failure
            case .unexpected:
                cell.imageView?.image = CIODebugStyle.tinted("questionmark.circle.fill", CIODebugStyle.secondaryText)
                cell.detailTextLabel?.text = "Not part of this journey · #\(extra.event.sequence)"
            }
            if case .outOfOrder = extra.kind {} else {
                cell.detailTextLabel?.textColor = CIODebugStyle.secondaryText
            }
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        }
        return cell
    }

    @objc private func recordTapped() {
        self.record()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let report = self.report else { return }
        switch self.sections[indexPath.section] {
        case .steps:
            let result = report.steps[indexPath.row]
            guard result.event != nil else { return }
            self.navigationController?.pushViewController(CIOJourneyStepViewController(result: result), animated: true)
        case .extras:
            self.navigationController?.pushViewController(CIODebugEventDetailViewController(event: report.extraEvents[indexPath.row].event), animated: true)
        case .summary:
            break
        }
    }
}

/// Every parameter check for one step, with a link to the full event
final class CIOJourneyStepViewController: UITableViewController {

    private let result: CIOJourneyStepResult

    init(result: CIOJourneyStepResult) {
        self.result = result
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
        self.title = "Step \(self.result.index + 1)"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return self.result.step.event
        case 1: return "Parameter checks"
        default: return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return max(self.result.findings.count, 1)
        default: return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0

        switch indexPath.section {
        case 0:
            cell.imageView?.image = CIOJourneyStyle.statusImage(self.result.status)
            cell.textLabel?.text = self.result.statusDescription
            cell.textLabel?.textColor = CIOJourneyStyle.statusColor(self.result.status)
            var details = [self.result.step.instruction]
            if self.result.order == .outOfOrder {
                details.append("This event fired before the earlier steps had fired, so it wasn't accepted. Fire it at the point the step describes, after the previous step.")
            }
            cell.detailTextLabel?.text = details.joined(separator: "\n")
            cell.detailTextLabel?.textColor = CIODebugStyle.secondaryText
        case 1:
            guard !self.result.findings.isEmpty else {
                cell.textLabel?.text = "No parameter checks for this step."
                cell.textLabel?.textColor = CIODebugStyle.secondaryText
                return cell
            }
            let finding = self.result.findings[indexPath.row]
            cell.imageView?.image = CIOJourneyStyle.findingImage(finding.severity)
            cell.textLabel?.text = finding.message
            cell.textLabel?.font = .systemFont(ofSize: 15)
            cell.detailTextLabel?.text = CIOJourneyReport.label(for: finding.severity)
            cell.detailTextLabel?.textColor = CIOJourneyStyle.findingColor(finding.severity)
        default:
            cell.textLabel?.text = "View event #\(self.result.event?.sequence ?? 0)"
            cell.textLabel?.textColor = self.view.tintColor
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 2, let event = self.result.event else { return }
        self.navigationController?.pushViewController(CIODebugEventDetailViewController(event: event), animated: true)
    }
}

enum CIOJourneyStyle {

    static func statusColor(_ status: CIOJourneyStepResult.Status) -> UIColor {
        switch status {
        case .passed: return CIODebugStyle.success
        case .warning: return CIODebugStyle.warning
        case .pending: return CIODebugStyle.secondaryText
        case .paramIssues, .outOfOrder, .rejected, .missing: return CIODebugStyle.failure
        }
    }

    static func statusImage(_ status: CIOJourneyStepResult.Status) -> UIImage? {
        let name: String
        switch status {
        case .passed: name = "checkmark.circle.fill"
        case .warning: name = "exclamationmark.circle.fill"
        case .paramIssues: name = "xmark.circle.fill"
        case .outOfOrder: name = "arrow.up.arrow.down.circle.fill"
        case .rejected: name = "exclamationmark.triangle.fill"
        case .missing: name = "minus.circle.fill"
        case .pending: name = "circle.dashed"
        }
        return CIODebugStyle.tinted(name, self.statusColor(status))
    }

    static func findingColor(_ severity: CIOJourneyFinding.Severity) -> UIColor {
        switch severity {
        case .passed: return CIODebugStyle.success
        case .warning: return CIODebugStyle.warning
        case .error: return CIODebugStyle.failure
        case .notVerified: return CIODebugStyle.secondaryText
        }
    }

    static func findingImage(_ severity: CIOJourneyFinding.Severity) -> UIImage? {
        let name: String
        switch severity {
        case .passed: name = "checkmark.circle.fill"
        case .warning: name = "exclamationmark.circle.fill"
        case .error: name = "xmark.circle.fill"
        case .notVerified: name = "questionmark.circle"
        }
        return CIODebugStyle.tinted(name, self.findingColor(severity))
    }

    static func verdictColor(_ verdict: CIOJourneyReport.Verdict) -> UIColor {
        switch verdict {
        case .inProgress: return CIODebugStyle.failure
        case .passed: return CIODebugStyle.success
        case .passedWithWarnings: return CIODebugStyle.warning
        case .failed: return CIODebugStyle.failure
        }
    }

    static func verdictImage(_ verdict: CIOJourneyReport.Verdict) -> UIImage? {
        switch verdict {
        case .inProgress: return CIODebugStyle.tinted("record.circle.fill", CIODebugStyle.failure)
        case .passed: return CIODebugStyle.tinted("checkmark.seal.fill", CIODebugStyle.success)
        case .passedWithWarnings: return CIODebugStyle.tinted("exclamationmark.circle.fill", CIODebugStyle.warning)
        case .failed: return CIODebugStyle.tinted("xmark.octagon.fill", CIODebugStyle.failure)
        }
    }
}
