//
//  ExpenseTracerApp.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI
import WidgetKit

@main
struct ExpenseTracerApp: App {
    @Environment(\.scenePhase) private var scene
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scene, { oldValue, newValue in
                    if newValue == .background || newValue == .active {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                })
        }
        .modelContainer(SharedModelContainer.shared)
    }
}
