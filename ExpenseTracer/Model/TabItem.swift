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
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .recents:
            Image(systemName: "book.pages")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)
        case .charts:
            Image(systemName: "chart.line.uptrend.xyaxis")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gear")
            Text(self.rawValue)
        }
    }
}
