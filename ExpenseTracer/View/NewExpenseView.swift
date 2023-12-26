//
//  NewExpenseView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 26/12/23.
//

import SwiftUI

struct NewExpenseView: View {
    // View Properties
    @State private var title: String = ""
    @State private var remark: String = ""
    @State private var amount:Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category:Category = .expence
    // Random Tint
    var tint = tints.randomElement()!
    
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: 15, content: {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                // Preview transaction card view
                TransActionCardView(transAction: .init(title: title,remark: remark.isEmpty ? "Remarks":remark,amount: amount,dateAdded: dateAdded,category: category,tintColor: tint))
                
                CustomSection("Title", "Magic keyboard" ,value: $title)
                
                CustomSection("Remarks","Apple Product!" , value: $remark)
                
                // Amount and category checkbox
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Amount and Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    HStack(spacing: 15, content: {
                        TextField("0.0", value: $amount , formatter: numberFormatter)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(.background, in: .rect(cornerRadius: 10))
                            .frame(maxWidth: 130)
                            .keyboardType(.decimalPad)
                        
                        // Custom Check Box
                        CustomCheckBox()
                    })
                    
                    // Date Picker
                    
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text("Date")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                        
                        DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(.background, in: .rect(cornerRadius: 10))
                    })
                    
                })
                
            })
            .padding(15)
        }
        .navigationTitle("Add Transaction")
        .background(.gray.opacity(0.15))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save"){
                    save()
                }
            }
        }
    }
    func save(){
        
    }
    @ViewBuilder
    func CustomSection(_ title:String,_ hint:String, value:Binding<String>) -> some View {
        VStack(alignment:.leading, spacing: 10){
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            TextField(hint, text: value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
        }
    }
    
    @ViewBuilder
    func CustomCheckBox()-> some View {
        HStack(spacing: 10) {
            ForEach(Category.allCases, id: \.rawValue){ category in
                HStack(spacing: 5){
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundColor(appTint)
                        
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundColor(appTint )
                        }
                    }
                    
                    Text(category.rawValue)
                        .font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture {
                    self.category = category
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical , 12)
        .hSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }
    // Number Formatter
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }
}

#Preview {
    NavigationStack{
        NewExpenseView()
    }
}
