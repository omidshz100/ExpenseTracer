//
//  Settings.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI

struct ApplicationSettings: View {
    /// User Properties
    @AppStorage("userName") private var userName: String = ""
    /// App Lock Properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    @AppStorage(AppLanguage.storageKey) private var appLanguageCode = AppLanguage.resolvedCode
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(selection: $appLanguageCode) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.nativeName)
                                .tag(language.rawValue)
                        }
                    } label: {
                        Text(AppLanguage.text("Language"))
                    }
                } header: {
                    Text(AppLanguage.text("Language"))
                }

                Section {
                    TextField(AppLanguage.text("Your name"), text: $userName)
                } header: {
                    Text(AppLanguage.text("User Name"))
                }
                
                Section {
                    Toggle(AppLanguage.text("Enable App Lock"), isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle(AppLanguage.text("Lock When App Goes Background"), isOn: $lockWhenAppGoesBackground)
                    }
                } header: {
                    Text(AppLanguage.text("App Lock"))
                }
            }
            .navigationTitle(AppLanguage.text("Settings"))
        }
    }
}

#Preview {
    ContentView()
}
