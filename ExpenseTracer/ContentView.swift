//
//  ContentView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI

struct ContentView: View {
    /// Intro Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    /// App Lock Properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    /// Active Tab
    @State private var activeTab: TabItem = .recents
    var body: some View {
        LockView(lockType: .biometric, lockPin: "", isEnabled: isAppLockEnabled, lockWhenAppGoesBackground: lockWhenAppGoesBackground) {
            TabView(selection: $activeTab) {
                RecentTransactions()
                    .tag(TabItem.recents)
                    .tabItem { TabItem.recents.tabContent }
                
                SearchAmongTransActions()
                    .tag(TabItem.search)
                    .tabItem { TabItem.search.tabContent }
                
                GraphForTransactions()
                    .tag(TabItem.charts)
                    .tabItem { TabItem.charts.tabContent }
                
                ApplicationSettings()
                    .tag(TabItem.settings)
                    .tabItem { TabItem.settings.tabContent }
            }
            .tint(appTintCustom)
            .sheet(isPresented: $isFirstTime, content: {
                SplashScreen()
                    .interactiveDismissDisabled()
            })
        }
    }
}

#Preview {
    ContentView()
}
