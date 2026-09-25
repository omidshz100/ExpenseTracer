//
//  Graphs.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//


import SwiftUI
import Charts
import SwiftData


struct GraphForTransactions: View {
    
    
    /// View Properties
    @Query(animation: .snappy) private var transactions: [TransactionModel]

    private var chartGroups: [ChartGroup] {
        let sources = transactions.map { transaction in
            ChartSource(amount: transaction.amount, date: transaction.dateAdded, category: transaction.category)
        }
        return ChartGrouping.groups(from: sources)
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    if !chartGroups.isEmpty {
                        ChartView()
                            .frame(height: 200)
                            .padding(10)
                            .padding(.top, 10)
                            .background(.background, in: .rect(cornerRadius: 10))
                    }
                    
                    ForEach(chartGroups) { group in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(format(date: group.date, format: "MMM yy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .hSpacingForView(.leading)
                            
                            NavigationLink {
                                ListOfExpenses(month: group.date)
                            } label: {
                                CardView(income: group.totalIncome, expense: group.totalExpense)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Graphs")
            .background(.gray.opacity(0.15))
            .overlay {
                if transactions.isEmpty {
                    ContentUnavailableView("No Transactions Found", systemImage: "xmark.seal")
                }
            }
        }
    }
    
    @ViewBuilder
    func ChartView() -> some View {
        /// Chart View
        Chart {
            ForEach(chartGroups) { group in
                ForEach(group.categories) { chart  in
                    BarMark(
                        x: .value("Month", format(date: group.date, format: "MMM yy")),
                        y: .value(chart.category.rawValue, chart.totalValue),
                        width: 20
                    )
                    .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.category.rawValue))
                }
            }
        }
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? 0
                
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    Text(axisLabel(doubleValue))
                }
            }
        }
        /// Foreground Colors
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
        .modifier(ChartScrollModifier(monthCount: chartGroups.count))
    }
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = intValue / 1000
        
        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
    }
}

private struct ChartScrollModifier: ViewModifier {
    var monthCount: Int

    @ViewBuilder
    func body(content: Content) -> some View {
        if monthCount > 4 {
            content
                .chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: 4)
        } else {
            content
        }
    }
}

/// List Of Transactions for the Selected Month
struct ListOfExpenses: View {
    let month: Date
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                Section {
                    FilterTransactionsView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .income) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink {
                                TransactionIncomeExpenseView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Income")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacingForView(.leading)
                }
                
                Section {
                    FilterTransactionsView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .expense) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink {
                                TransactionIncomeExpenseView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Expense")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacingForView(.leading)
                }
            }
            .padding(15)
        }
        .background(.gray.opacity(0.15))
        .navigationTitle(format(date: month, format: "MMM yy"))
    }
}

#Preview {
    GraphForTransactions()
}
