//
//  Tab.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI

enum TabItem: String {
    case recents = "RecentsTab"
    case search = "FilterTab"
    case charts = "ChartsTab"
    case settings = "SettingsTab"
    
    var title: String {
        switch self {
        case .recents:
            return AppLanguage.text("Recents")
        case .search:
            return AppLanguage.text("Search")
        case .charts:
            return AppLanguage.text("Charts")
        case .settings:
            return AppLanguage.text("Settings")
        }
    }

    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .recents:
            Image(systemName: "book.pages")
            Text(title)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(title)
        case .charts:
            Image(systemName: "chart.line.uptrend.xyaxis")
            Text(title)
        case .settings:
            Image(systemName: "gear")
            Text(title)
        }
    }
}
