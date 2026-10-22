//
//  CIOJourneyListViewController.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

/// Lists the journeys from the journey file. Selecting one opens it, where recording is started.
final class CIOJourneyListViewController: UITableViewController {

    private enum Section {
        case current
        case journeys
        /// Shown instead of the journeys while loading or when the file couldn't be loaded
        case status(String)
    }

    private var journeys: [CIOJourney] = []
    private var sections: [Section] = []

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
        self.title = "Tracking Journeys"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.close))

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshJourneys), for: .valueChanged)
        self.refreshControl = refresh

        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: CIOJourneySession.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: CIOJourneyLibrary.didChangeNotification, object: nil)
        self.reload()

        // Pick up edits to the hosted file each time the tab opens
        if !CIOJourneyLibrary.shared.isLoading {
            CIOJourneyLibrary.shared.refresh()
        }
    }

    @objc private func refreshJourneys() {
        CIOJourneyLibrary.shared.refresh()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func reload() {
        let library = CIOJourneyLibrary.shared
        self.journeys = library.journeys
        if !library.isLoading {
            self.refreshControl?.endRefreshing()
        }
        var sections: [Section] = CIOJourneySession.shared.journey == nil ? [] : [.current]
        if !self.journeys.isEmpty {
            sections.append(.journeys)
        } else {
            switch library.state {
            case .idle, .loading:
                sections.append(.status("Loading journeys…"))
            case .failed(let reason):
                sections.append(.status("Couldn't load journeys: \(reason) Pull down to try again."))
            case .loaded:
                sections.append(.status("The journey file has no journeys."))
            }
        }
        self.sections = sections
        self.tableView.reloadData()
    }

    @objc private func close() {
        self.dismiss(animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.sections[section] {
        case .current:
            return 1
        case .journeys:
            return self.journeys.count
        case .status:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.textColor = CIODebugStyle.secondaryText
        cell.detailTextLabel?.numberOfLines = 0

        switch self.sections[indexPath.section] {
        case .current:
            let session = CIOJourneySession.shared
            cell.textLabel?.text = session.journey?.name
            if let report = session.report {
                let progress = "\(report.completedStepCount)/\(report.steps.count) steps"
                cell.detailTextLabel?.text = session.isRecording ? "\(progress) · tap to see progress or stop" : "\(report.verdictDescription) · \(report.summary)"
                cell.imageView?.image = CIOJourneyStyle.verdictImage(report.verdict)
            }
            cell.accessibilityIdentifier = "cio-journey-current"
        case .journeys:
            let journey = self.journeys[indexPath.row]
            cell.textLabel?.text = journey.name
            cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            cell.detailTextLabel?.text = journey.description
            cell.imageView?.image = CIODebugStyle.tinted("record.circle", CIODebugStyle.failure)
            cell.accessibilityIdentifier = "cio-journey-\(journey.id)"
        case .status(let message):
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.textLabel?.text = message
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = CIODebugStyle.secondaryText
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch self.sections[indexPath.section] {
        case .current:
            guard let journey = CIOJourneySession.shared.journey else { return }
            self.navigationController?.pushViewController(CIOJourneyRunViewController(journey: journey), animated: true)
        case .journeys:
            self.navigationController?.pushViewController(CIOJourneyRunViewController(journey: self.journeys[indexPath.row]), animated: true)
        case .status:
            break
        }
    }
}
