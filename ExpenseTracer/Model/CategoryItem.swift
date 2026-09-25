//
//  Category.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI

enum CategoryItem: String, CaseIterable {
    case income = "Income"
    case expense = "Expense"

    var title: String {
        switch self {
        case .income:
            return AppLanguage.text("Income")
        case .expense:
            return AppLanguage.text("Expense")
        }
    }
}
