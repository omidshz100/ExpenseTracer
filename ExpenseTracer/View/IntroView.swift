//
//  IntroView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI

struct IntroView: View {
    // visibility status
    @AppStorage("first-time") private var isFirstTime:Bool = true
    var body: some View {
        VStack(spacing: 15)
            {
                Text("multi text like ")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.top, 65)
                    .padding(.bottom, 35)
                // Point view
                VStack(alignment: .leading , spacing: 25) {
                    PointView(symb: "dollarsign", title: "Transaction", subTitle: "keep track of your earnings and expenses")
                    PointView(symb: "chart.bar.fill", title: "Transaction", subTitle: "keep track of your earnings and expenses")
                    PointView(symb: "magnifyingglass", title: "Transaction", subTitle: "keep track of your earnings and expenses")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                Spacer(minLength: 10)
                Button(action: {
                    isFirstTime = false
                }, label: {
                    Text("Continue")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(appTint.gradient, in: .rect(cornerRadius: 12))
                        .contentShape(.rect)
                })
        }
        .padding(15)
    }
    // View builder the Icone of each row like: magnifier, chart, ... 
    @ViewBuilder
    func PointView(symb:String, title:String, subTitle:String) -> some View{
        HStack(spacing: 20){
            Image(systemName: symb)
                .font(.largeTitle)
                .foregroundStyle(appTint.gradient)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 16){
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(subTitle)
                    .foregroundStyle(.gray )
            }
        }
    }
}

#Preview {
    IntroView()
}
