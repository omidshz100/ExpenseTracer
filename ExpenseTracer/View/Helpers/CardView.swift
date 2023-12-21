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
                    ForEach(Category.allCases, id:\.rawValue ){ category in
                        
                        let symbolImageName:String = category == .income ? "arrow.down":"arrow.up"
                        let tint:Color = category == .income ? .green:.red
                        
                        
                        HStack(spacing: 10){
                            Image(systemName: symbolImageName)
                                .font(.callout.bold())
                                .foregroundColor(tint)
                                .frame(width:35, height:35)
                                .background(){
                                    Circle()
                                        .fill(tint.opacity(0.25).gradient)
                                }
                            
                            VStack(alignment:.leading, spacing:4){
                                Text(category.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                                Text(currencyString( category == .income ? income:expence , alowedDigits:0))
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                            }
                            
                            if category == .income {
                                Spacer(minLength: 10)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 25)
            .padding(.top, 15)
            
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 400, expence: 300)
    }
}
