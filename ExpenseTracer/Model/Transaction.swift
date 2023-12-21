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
    var amount:String
    var dateAdded:String
    var category:String
    var tintColor:String
    
    init(id: UUID, title: String, remark: String, amount: String, dateAdded: String, category: Category, tintColor: TintColor) {
        self.id = id
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
