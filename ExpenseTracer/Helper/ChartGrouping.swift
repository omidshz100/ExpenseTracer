//
//  ChartGrouping.swift
//  ExpenseTracer
//

import Foundation

struct ChartSource: Sendable {
    var amount: Double
    var date: Date
    var category: String
}

enum ChartGrouping {
    static func groups(from sources: [ChartSource], calendar: Calendar = .current) -> [ChartGroup] {
        let grouped = Dictionary(grouping: sources) { source in
            calendar.dateComponents([.year, .month], from: source.date)
        }

        let sorted = grouped.sorted { lhs, rhs in
            let leftDate = calendar.date(from: lhs.key) ?? .distantPast
            let rightDate = calendar.date(from: rhs.key) ?? .distantPast
            return leftDate > rightDate
        }

        return sorted.map { key, values in
            let date = calendar.date(from: key) ?? .distantPast
            let income = total(values, category: .income)
            let expense = total(values, category: .expense)
            return ChartGroup(
                date: date,
                categories: [
                    ChartCategory(totalValue: income, category: .income),
                    ChartCategory(totalValue: expense, category: .expense)
                ],
                totalIncome: income,
                totalExpense: expense
            )
        }
    }

    private static func total(_ sources: [ChartSource], category: CategoryItem) -> Double {
        sources.reduce(0) { partial, source in
            source.category == category.rawValue ? partial + source.amount : partial
        }
    }
}
