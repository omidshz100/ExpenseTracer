//
//  File.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 08/04/24.
//

import SwiftUI
import SwiftData

/// Custom View
struct FilterTransactionsView<Content: View>: View {
    var content: ([TransactionModel]) -> Content
    
    @Query(animation: .snappy) private var transactions: [TransactionModel]
    init(category: CategoryItem?, searchText: String, @ViewBuilder content: @escaping ([TransactionModel]) -> Content) {
        /// Custom Predicate
        
        let rawValue = category?.rawValue ?? ""
        let predicate = #Predicate<TransactionModel> { transaction in
            return (transaction.title.localizedStandardContains(searchText) || transaction.remarks.localizedStandardContains(searchText)) && (rawValue.isEmpty ? true : transaction.category == rawValue)
        }
        
        _transactions = Query(filter: predicate, sort: [
            SortDescriptor(\TransactionModel.dateAdded, order: .reverse)
        ], animation: .snappy)
        
        self.content = content
    }
    
    init(startDate: Date, endDate: Date, newestFirst: Bool = true, @ViewBuilder content: @escaping ([TransactionModel]) -> Content) {
        /// Custom Predicate
        let predicate = #Predicate<TransactionModel> { transaction in
            return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate
        }
        let order: SortOrder = newestFirst ? .reverse : .forward
        
        _transactions = Query(filter: predicate, sort: [
            SortDescriptor(\TransactionModel.dateAdded, order: order)
        ], animation: .snappy)
        
        self.content = content
    }
    
    /// Optional For Your Customized Usage
    init(startDate: Date, endDate: Date, category: CategoryItem?, @ViewBuilder content: @escaping ([TransactionModel]) -> Content) {
        /// Custom Predicate
        
        let rawValue = category?.rawValue ?? ""
        let predicate = #Predicate<TransactionModel> { transaction in
            return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate && (rawValue.isEmpty ? true : transaction.category == rawValue)
        }
        
        _transactions = Query(filter: predicate, sort: [
            SortDescriptor(\TransactionModel.dateAdded, order: .reverse)
        ], animation: .snappy)
        
        self.content = content
    }
    
    
    var body: some View {
        content(transactions)
    }
}
