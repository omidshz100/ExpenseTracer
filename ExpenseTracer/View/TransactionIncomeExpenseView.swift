//
//  TransactionView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 08/04/24.
//


import SwiftUI
import WidgetKit

struct TransactionIncomeExpenseView: View {
    /// Env Properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var editTransaction: TransactionModel?
    /// View Properties
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category: CategoryItem = .expense
    /// Random Tint
    @State var tint: TintColor = tints.randomElement()!
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                Text(AppLanguage.text("Preview"))
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacingForView(.leading)
                
                /// Preview Transaction Card View
                TransactionCardView(transaction: .init(
                    title: title.isEmpty ? AppLanguage.text("Title") : title,
                    remarks: remarks.isEmpty ? AppLanguage.text("Remarks") : remarks,
                    amount: amount,
                    dateAdded: dateAdded,
                    category: category,
                    tintColor: tint
                ))
                
                CustomSection(AppLanguage.text("Title"), AppLanguage.text("Magic Keyboard"), value: $title)
                
                CustomSection(AppLanguage.text("Remarks"), AppLanguage.text("Apple Product!"), value: $remarks)
                
                /// Amount & Category Check Box
                VStack(alignment: .leading, spacing: 10, content: {
                    Text(AppLanguage.text("Amount & Category"))
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacingForView(.leading)
                    
                    HStack(spacing: 15) {
                        HStack(spacing: 4) {
                            Text(currencySymbol)
                                .font(.callout.bold())
                            
                            TextField("0.0", value: $amount, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .frame(maxWidth: 130)
                        
                        /// Custom Check Box
                        CategoryCheckBox()
                    }
                })
                
                /// Date Picker
                VStack(alignment: .leading, spacing: 10, content: {
                    Text(AppLanguage.text("Date"))
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacingForView(.leading)
                    
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                })
            }
            .padding(15)
        }
        .navigationTitle(editTransaction == nil ? AppLanguage.text("Add Transaction") : AppLanguage.text("Edit Transaction"))
        .background(.gray.opacity(0.15))
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(AppLanguage.text("Save"), action: save)
            }
        })
        .onAppear(perform: {
            if let editTransaction {
                /// Load All Existing Data from the Transaction
                title = editTransaction.title
                remarks = editTransaction.remarks
                dateAdded = editTransaction.dateAdded
                if let category = editTransaction.rawCategory {
                    self.category = category
                }
                amount = editTransaction.amount
                if let tint = editTransaction.tint {
                    self.tint = tint
                }
            }
        })
    }
    
    /// Saving Data
    func save() {
        /// Saving Item to SwiftData
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.remarks = remarks
            editTransaction?.amount = amount
            editTransaction?.category = category.rawValue
            editTransaction?.dateAdded = dateAdded
        } else {
            let transaction = TransactionModel(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            context.insert(transaction)
        }
        
        /// Dismissing View
        dismiss()
        /// Updating Widgets
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @ViewBuilder
    func CustomSection(_ title: String, _ hint: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacingForView(.leading)
            
            TextField(hint, text: value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
        })
    }
    
    /// Custom CheckBox
    @ViewBuilder
    func CategoryCheckBox() -> some View {
        HStack(spacing: 10) {
            ForEach(CategoryItem.allCases, id: \.rawValue) { category in
                HStack(spacing: 5) {
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTintCustom)
                        
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(appTintCustom)
                        }
                    }
                    
                    Text(category.title)
                        .font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture {
                    self.category = category
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .hSpacingForView(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    /// Number Formatter
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = AppLanguage.current.locale
        
        return formatter
    }
}

#Preview {
    NavigationStack {
        TransactionIncomeExpenseView()
    }
}
