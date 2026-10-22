//
//  CIODebugTabBarController.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

/// The debug screen opened from the floating button: the event log and journey testing, side by side
final class CIODebugTabBarController: UITabBarController {

    enum Tab: Int {
        case events
        case journeys
    }

    init(selectedTab: Tab) {
        super.init(nibName: nil, bundle: nil)

        let events = UINavigationController(rootViewController: CIODebugEventListViewController())
        events.tabBarItem = UITabBarItem(title: "Events", image: CIODebugStyle.symbol("list.bullet"), tag: Tab.events.rawValue)
        events.tabBarItem.accessibilityIdentifier = "cio-debug-tab-events"

        let journeys = UINavigationController(rootViewController: CIOJourneyListViewController())
        journeys.tabBarItem = UITabBarItem(title: "Tracking Journeys", image: CIODebugStyle.symbol("point.topleft.down.curvedto.point.bottomright.up"), tag: Tab.journeys.rawValue)
        journeys.tabBarItem.accessibilityIdentifier = "cio-debug-tab-journeys"

        self.viewControllers = [events, journeys]
        self.selectedIndex = selectedTab.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
