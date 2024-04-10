//
//  CartModel.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 08/04/24.
//

import Foundation

import SwiftUI

struct ChartGroup: Identifiable {
    let id: UUID = .init()
    var date: Date
    var categories: [ChartCategory]
    var totalIncome: Double
    var totalExpense: Double
}

struct ChartCategory: Identifiable {
    let id: UUID = .init()
    var totalValue: Double
    var category: CategoryItem
}
