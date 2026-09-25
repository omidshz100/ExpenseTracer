//
//  Transaction.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI
import SwiftData

@Model
class TransactionModel {
    /// Properties
    var title: String
    var remarks: String
    /// Kept so existing records still open. New money is stored in `amountDecimal`.
    var amount: Double
    var amountDecimal: Decimal = 0
    var dateAdded: Date
    var category: String
    var tintColor: String

    var money: Decimal {
        get {
            amountDecimal == 0 ? Decimal(amount) : amountDecimal
        }
        set {
            amountDecimal = newValue
            amount = NSDecimalNumber(decimal: newValue).doubleValue
        }
    }
    
    init(title: String, remarks: String, amount: Decimal, dateAdded: Date, category: CategoryItem, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = NSDecimalNumber(decimal: amount).doubleValue
        self.amountDecimal = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    /// Extracting Color Value from tintColor String
    @Transient
    var color: Color {
        return tints.first(where: { $0.color == tintColor })?.value ?? appTintCustom
    }
    
    @Transient
    var tint: TintColor? {
        return tints.first(where: { $0.color == tintColor })
    }
    
    @Transient
    var rawCategory: CategoryItem? {
        return CategoryItem.allCases.first(where: { category == $0.rawValue })
    }
}
