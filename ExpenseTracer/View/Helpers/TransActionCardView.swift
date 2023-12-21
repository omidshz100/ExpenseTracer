//
//  TransActionCardView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 21/12/23.
//

import SwiftUI

struct TransActionCardView: View {
    var transAction:Transaction
    
    var body: some View {
        SwipeAction(cornerRadius: 10, direction: .trailing) {
            HStack(spacing:10){
                Text("\(String(transAction.title.prefix(1)))")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                // 😎 you can use " in: Circle() " in bacground to shape the background
                    .background(transAction.color.gradient, in: Circle())
                
                VStack(alignment: .leading, spacing:4){
                    Text("\(transAction.title)")
                        .foregroundStyle(Color.primary)
                    
                    Text("\(transAction.remark)")
                        .foregroundStyle(Color.primary.secondary)
                    
                    Text("\(dateFormat(date:transAction.dateAdded,format: "dd MMM yyyy"))")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                // ❓⚠️ what is " lineLimit "
                .lineLimit(1)
                .hSpacing(.leading)
                
                Text(currencyString( transAction.amount, alowedDigits: 2))
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.background, in: .rect(cornerRadius: 10))
        } actions: {
            Action(tint: .red, icon: "trash"){
                // TO DO LATER ....
                print("Item removed .... ")
            }
            
        }
    }
}

#Preview {
    TransActionCardView(transAction: sampleTransActions[0])
}
