//
//  ContentView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ContentView: View {
    /// Intro Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    /// App Lock Properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    /// Active Tab
    @State private var activeTab: TabItem = .recents
    @Environment(\.modelContext) private var context
    @AppStorage("didInsertSampleTransactions") private var didInsertSampleTransactions = false
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
        .onAppear {
            migrateAmountsToDecimal()
            insertSampleTransactionsIfNeeded()
        }
    }

    private func insertSampleTransactionsIfNeeded() {
        guard !didInsertSampleTransactions else { return }
        let calendar = Calendar.current
        let expenses = [
            ("Groceries", "Weekly shop"),
            ("Rent", "Apartment"),
            ("Coffee", "Cafe"),
            ("Transport", "Metro card"),
            ("Restaurant", "Dinner"),
            ("Pharmacy", "Medicine"),
            ("Electricity", "Utility bill"),
            ("Internet", "Home connection"),
            ("Clothes", "Shopping"),
            ("Fuel", "Car")
        ]
        let incomes = [
            ("Salary", "Monthly pay"),
            ("Freelance", "Project"),
            ("Refund", "Returned purchase")
        ]

        for index in 0..<100 {
            let dayOffset = index * 2
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: .now) ?? .now
            let isIncome = index.isMultiple(of: 5)
            let source = isIncome ? incomes[index % incomes.count] : expenses[index % expenses.count]
            let amount: Decimal = isIncome ? Decimal(1800 + (index % 7) * 150) : Decimal(8 + (index % 23) * 7)
            let transaction = TransactionModel(
                title: source.0,
                remarks: source.1,
                amount: amount,
                dateAdded: date,
                category: isIncome ? .income : .expense,
                tintColor: tints[index % tints.count]
            )
            context.insert(transaction)
        }

        didInsertSampleTransactions = true
        WidgetCenter.shared.reloadAllTimelines()
    }

    /// Copies older floating-point amounts into the exact decimal field once.
    private func migrateAmountsToDecimal() {
        guard let transactions = try? context.fetch(FetchDescriptor<TransactionModel>()) else { return }
        var changed = false
        for transaction in transactions where transaction.amountDecimal == 0 && transaction.amount != 0 {
            transaction.amountDecimal = Decimal(transaction.amount)
            changed = true
        }
        if changed {
            try? context.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview {
    ContentView()
}
