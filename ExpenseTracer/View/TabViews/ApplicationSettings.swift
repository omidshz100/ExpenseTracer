//
//  Settings.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ApplicationSettings: View {
    /// App Lock Properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    @Environment(\.modelContext) private var modelContext
    @State private var showClearConfirmation = false
    var body: some View {
        NavigationStack {
            List {
                Section("App Lock") {
                    Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle("Lock When App Goes Background", isOn: $lockWhenAppGoesBackground)
                    }
                }

                Section {
                    Button("Delete All Transactions", role: .destructive) {
                        showClearConfirmation = true
                    }
                } footer: {
                    Text("Removes every income and expense. App lock stays.")
                }
            }
            .confirmationDialog("Delete all transactions?", isPresented: $showClearConfirmation, titleVisibility: .visible) {
                Button("Delete All", role: .destructive, action: deleteAllTransactions)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This cannot be undone.")
            }
            .navigationTitle("Settings")
        }
    }

    private func deleteAllTransactions() {
        do {
            let transactions = try modelContext.fetch(FetchDescriptor<TransactionModel>())
            for transaction in transactions {
                modelContext.delete(transaction)
            }
            try modelContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {}
    }
}

#Preview {
    ContentView()
}
