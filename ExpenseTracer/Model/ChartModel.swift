//
//  CartModel.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 08/04/24.
//

import Foundation

struct ChartGroup: Identifiable, Sendable {
    let id: UUID = .init()
    var date: Date
    var categories: [ChartCategory]
    var totalIncome: Decimal
    var totalExpense: Decimal
}

struct ChartCategory: Identifiable, Sendable {
    let id: UUID = .init()
    var totalValue: Decimal
    var category: CategoryItem
}
