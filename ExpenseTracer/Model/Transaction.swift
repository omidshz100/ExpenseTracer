//
//  Transaction.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import Foundation
import SwiftUI


struct Transaction: Identifiable {
    var id:UUID = UUID()
    // properties
    var title:String
    var remark:String
    var amount:Double
    var dateAdded:Date
    var category:String
    var tintColor:String
    
    init(title: String, remark: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
        self.title = title
        self.remark = remark
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }

    // Extracting color value from tintColor String
    var color:Color {
        return tints.first(where: {$0.color == tintColor})?.value ?? appTint
    }
}


// Sample Transactions for UI building
var sampleTransActions:[Transaction] = [
    Transaction( title: "MurtZilo", remark: "Food and Drinks", amount: 3.00, dateAdded: .now, category: .expence, tintColor: tints.randomElement()!),
    Transaction(title: "HeadPhone", remark: "Amazon", amount: 3.00, dateAdded: .now, category: .expence, tintColor: tints.randomElement()!),
    Transaction(title: "Printer", remark: "Ebay", amount: 3.00, dateAdded: .now, category: .expence, tintColor: tints.randomElement()!),
    Transaction(title: "Monthly Incom", remark: "Salary", amount: 3.00, dateAdded: .now, category: .income, tintColor: tints.randomElement()!),
    Transaction(title: "MacBook", remark: "Apple", amount: 3.00, dateAdded: .now, category: .expence, tintColor: tints.randomElement()!),
    Transaction(title: "Refund", remark: "iO Resume", amount: 3.00, dateAdded: .now, category: .expence, tintColor: tints.randomElement()!),
]
