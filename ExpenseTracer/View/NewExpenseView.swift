//
//  NewExpenseView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 26/12/23.
//

import SwiftUI

struct NewExpenseView: View {
    // Env property
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var editTransAction:Transaction?
    // View Properties
    @State private var title: String = ""
    @State private var remark: String = ""
    @State private var amount:Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category:Category = .expence
    // Random Tint
    @State var tint = tints.randomElement()!
    
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
                        HStack(spacing: 4){
                            Text(currencySymbol)
                                .font(.callout.bold())
                            
                            
                            TextField("0.0", value: $amount , formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .frame(maxWidth: 130)
                            
                        
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
        .navigationTitle("\(editTransAction != nil ? "Edit ":"Add ") Transaction")
        .background(.gray.opacity(0.15))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save"){
                    save()
                }
            }
        }
        .onAppear(){
            if let _ = self.editTransAction {
                title = self.editTransAction!.title
                remark = self.editTransAction!.remark
                amount = self.editTransAction!.amount
                dateAdded = self.editTransAction!.dateAdded
                if let category = self.editTransAction!.rawCategory {
                    self.category = category
                }
                if let tint = self.editTransAction!.tint {
                    self.tint = tint
                }
            }
        }
    }
    func save(){
        // saving Item to SwiftData
        if editTransAction != nil {
            editTransAction?.title = title
            editTransAction?.remark = remark
            editTransAction?.amount = amount
            editTransAction?.dateAdded = dateAdded
            editTransAction?.category = category.rawValue
        }else{
            let newTransAction = Transaction(title: title, remark: remark, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            context.insert(newTransAction)
        }
        
        
        // Dismissing View
        dismiss()
        
        
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
