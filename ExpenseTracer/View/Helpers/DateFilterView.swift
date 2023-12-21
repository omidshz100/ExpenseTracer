//
//  DateFilterView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 21/12/23.
//

import SwiftUI

struct DateFilterView: View {
    @State var start:Date
    @State var end:Date
    var onSubmit:(Date, Date)->()
    var onClose:()->()
     
    var body: some View {
        VStack(spacing: 15){
            DatePicker("Start Date", selection: $start, displayedComponents: [.date])
            
            DatePicker("End  Date", selection: $end, displayedComponents: [.date])
            
            
            HStack(spacing: 16){
                Button("Cancel"){
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .tint(.red)
                
                Button("Filter"){
                    onSubmit(start, end )
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .tint(.red)
            }
            .padding(.top, 10)
        }
        .padding(15)
        .background(.bar, in: .rect(cornerRadius: 10))
        .padding(.horizontal, 30)
    }
}

#Preview {
    DateFilterView(start: .now, end: .now, onSubmit: { sd , sdsd in }, onClose: {})
}
