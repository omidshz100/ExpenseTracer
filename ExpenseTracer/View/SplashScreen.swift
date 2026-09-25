//
//  IntroView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI

struct SplashScreen: View {
    /// Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    var body: some View {
        VStack(spacing: 15) {
            Text(AppLanguage.text("What's New in the\nExpense Tracker"))
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            
            /// Points View
            VStack(alignment: .leading, spacing: 25, content: {
                PointView(symbol: "dollarsign", title: AppLanguage.text("Transactions"), subTitle: AppLanguage.text("Keep track of your earnings and expenses."))
                
                PointView(symbol: "chart.bar.fill", title: AppLanguage.text("Visual Charts"), subTitle: AppLanguage.text("View your transactions using eye-catching graphic representations."))
                
                PointView(symbol: "magnifyingglass", title: AppLanguage.text("Advance Filters"), subTitle: AppLanguage.text("Find the expenses you want by advance search and filtering."))
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            Spacer(minLength: 10)
            
            Button(action: {
                isFirstTime = false
            }, label: {
                Text(AppLanguage.text("Continue"))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(appTintCustom.gradient, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
            })
        }
        .padding(15)
    }
    
    /// Point View
    @ViewBuilder
    func PointView(symbol: String, title: String, subTitle: String) -> some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTintCustom.gradient)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 6, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .font(.callout)
                    .foregroundStyle(.gray)
            })
        }
    }
}

#Preview {
    SplashScreen()
}
