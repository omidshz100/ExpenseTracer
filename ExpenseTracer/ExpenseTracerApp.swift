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
    @AppStorage(AppLanguage.storageKey) private var appLanguageCode = AppLanguage.resolvedCode

    private var appLanguage: AppLanguage {
        AppLanguage.language(for: appLanguageCode)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, appLanguage.locale)
                .environment(\.layoutDirection, appLanguage.layoutDirection)
                .id(appLanguageCode)
                .onChange(of: scene, { oldValue, newValue in
                    if newValue == .background {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                })
        }
        .modelContainer(for: [TransactionModel.self])
    }
}
