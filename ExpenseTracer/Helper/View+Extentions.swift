//
//  View+Extentions.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 20/12/23.
//

import Foundation
import SwiftUI


extension View {
    @ViewBuilder
    func hSpacingForView(_ alignment: Alignment = .center) -> some View {
        self
        .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacingForView(_ alignment: Alignment = .center) -> some View {
        self
        .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    @available(iOSApplicationExtension, unavailable)
    var safeArea: UIEdgeInsets {
        if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene) {
            return windowScene.keyWindow?.safeAreaInsets ?? .zero
        }
        
        return .zero
    }
    
    func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = AppLanguage.current.locale
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func currencyStringGenerator(_ value: Double, allowedDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = allowedDigits
        formatter.locale = AppLanguage.current.locale
        if let code = Locale.current.currency?.identifier {
            formatter.currencyCode = code
        }
        
        return formatter.string(from: .init(value: value)) ?? ""
    }
    
    var currencySymbol: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = AppLanguage.current.locale
        if let code = Locale.current.currency?.identifier {
            formatter.currencyCode = code
        }
        
        return formatter.currencySymbol ?? Locale.current.currencySymbol ?? ""
    }
    
    func totalCalculator(_ transactions: [TransactionModel], category: CategoryItem) -> Double {
        return transactions.filter({ $0.category == category.rawValue }).reduce(Double.zero) { partialResult, transaction in
            return partialResult + transaction.amount
        }
    }
}
