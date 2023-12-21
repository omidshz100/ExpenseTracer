//
//  CardView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 21/12/23.
//

import SwiftUI

struct CardView: View {
    var income: Double
    var expence: Double
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
            
            VStack(spacing: 0){
                HStack(spacing: 12){
                     Text("\(currencyString((income - expence)))")
                        .font(.title.bold())
                  
                    Image(systemName: expence > income ? "chart.line.uptrend.xyaxis":"chart.line.downtrend.xyaxis")
                        .font(.title3)
                        .foregroundColor(expence > income ? .red: .green)
                 }
                .padding(.bottom, 25)
                
                HStack(spacing:0){
                    ForEach(
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 400, expence: 300)
    }
}
