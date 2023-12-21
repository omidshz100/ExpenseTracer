//
//  ContentView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI

struct ContentView: View {
    // visibility status
    @AppStorage("first-time") private var isFirstTime:Bool = true
    // Active Tab
    @State private var activeTab:Tab = .recent
    var body: some View {
        TabView(selection: $activeTab )
        {
            Recent()
                .tag(Tab.recent)
                .tabItem {
                    Tab.recent.tabContent
                }
            Search()
                .tag(Tab.search)
                .tabItem {
                    Tab.search.tabContent
                }
            Charts()
                .tag(Tab.charts)
                .tabItem {
                    Tab.charts.tabContent
                }
            Settings()
                .tag(Tab.settings)
                .tabItem {
                    Tab.settings.tabContent
                }
        }
        .tint(appTint)
        .sheet(isPresented: $isFirstTime, content: {
            IntroView()
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    ContentView()
}
