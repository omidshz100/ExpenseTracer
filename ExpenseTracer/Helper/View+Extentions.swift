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
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    var safeArea: UIEdgeInsets {
        if let windowScene = (UIApplication.shared.connectedScenes.first) as? UIWindowScene {
            return windowScene.keyWindow?.safeAreaInsets ?? .zero
        }
        return .zero
    }
    
    func dateFormat(date:Date, format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func currencyString(_ value:Double, alowedDigits: Int = 2) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = alowedDigits
        
        return numberFormatter.string(from: .init(value: value)) ?? "Unbale TO convert"
    }
}
