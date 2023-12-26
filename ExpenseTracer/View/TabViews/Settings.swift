//
//  Settings.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI
//
struct Settings: View {
    //User properties
    @AppStorage("userName") private var userName:String = ""
    // App lock properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled:Bool = false
    @AppStorage("lockeWhenAppGoesBackground") private var lockeWhenAppGoesBackground:Bool = false

    var body: some View {
        NavigationStack{
            List{
                Section("User Name"){
                    TextField("iJustin", text: $userName)
                }
                
                Section("App Lock"){
                    Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle("locke When App Goes Background", isOn: $lockeWhenAppGoesBackground)
                    }
                }
            }
        }
        .navigationTitle("Settings ")
    }
}

#Preview {
    ContentView()
}
