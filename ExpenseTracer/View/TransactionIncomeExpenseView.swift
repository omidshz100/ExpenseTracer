//
//  TransactionView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 08/04/24.
//


import SwiftUI
import UIKit
import WidgetKit

enum EntryField: Hashable {
    case amount
    case title
    case remarks
}

struct TransactionIncomeExpenseView: View {
    /// Env Properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var editTransaction: TransactionModel?
    /// View Properties
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var amountText: String = ""
    @State private var dateAdded: Date = .now
    @State private var category: CategoryItem = .expense
    /// Random Tint
    @State var tint: TintColor = tints.randomElement()!
    @FocusState private var focusedField: EntryField?
    var body: some View {
        ScrollViewReader { proxy in
        Form {
            Section {
                EntryPreview(
                    title: title.isEmpty ? "Title" : title,
                    remarks: remarks.isEmpty ? "Remarks" : remarks,
                    amount: amount,
                    dateAdded: dateAdded,
                    tint: tint.value
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            }

            Section("Amount") {
                TextField("0.0", text: $amountText)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .amount)
                    .id(EntryField.amount)
                    .onChange(of: amountText) { _, newValue in
                        let standardized = AmountText.standardize(newValue)
                        if standardized != newValue {
                            amountText = standardized
                        }
                        amount = AmountText.value(from: standardized)
                    }
                Picker("Type", selection: $category) {
                    ForEach(CategoryItem.allCases, id: \.self) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)
            }

            Section("Details") {
                TextField("Title", text: $title)
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                    .onSubmit(advanceFocus)
                    .id(EntryField.title)
                TextField("Remarks", text: $remarks)
                    .focused($focusedField, equals: .remarks)
                    .submitLabel(.done)
                    .onSubmit(closeKeyboard)
                    .id(EntryField.remarks)
            }

            Section("Color") {
                HStack(spacing: 14) {
                    ForEach(tints) { item in
                        Button {
                            tint = item
                        } label: {
                            Circle()
                                .fill(item.value)
                                .frame(width: 32, height: 32)
                                .overlay {
                                    if item.color == tint.color {
                                        Circle().strokeBorder(.primary, lineWidth: 2).padding(-4)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Section("Date") {
                DatePicker("Date", selection: $dateAdded, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
            }

            if !canSave {
                Text("Enter a title and an amount greater than zero.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .onChange(of: focusedField) { _, field in
            guard let field else { return }
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(250))
                withAnimation(.easeInOut(duration: 0.25)) {
                    proxy.scrollTo(field, anchor: UnitPoint(x: 0.5, y: 0.72))
                }
            }
        }
        }
        .navigationTitle("\(editTransaction == nil ? "Add" : "Edit") Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
                    .disabled(!canSave)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Button("Done", action: closeKeyboard)
                Spacer()
                if focusedField != .remarks {
                    Button("Next", action: advanceFocus)
                        .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            if let editTransaction {
                title = editTransaction.title
                remarks = editTransaction.remarks
                dateAdded = editTransaction.dateAdded
                if let category = editTransaction.rawCategory {
                    self.category = category
                }
                amount = editTransaction.amount
                amountText = numberFormatter.string(from: NSNumber(value: editTransaction.amount)) ?? ""
                if let tint = editTransaction.tint {
                    self.tint = tint
                }
            }
        }
    }

    private func advanceFocus() {
        switch focusedField {
        case .amount:
            focusedField = .title
        case .title:
            focusedField = .remarks
        default:
            closeKeyboard()
        }
    }

    private func closeKeyboard() {
        focusedField = nil
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedTitle.isEmpty && amount > 0
    }

    /// Saving Data
    func save() {
        guard canSave else { return }
        let cleanRemarks = remarks.trimmingCharacters(in: .whitespacesAndNewlines)
        /// Saving Item to SwiftData
        if editTransaction != nil {
            editTransaction?.title = trimmedTitle
            editTransaction?.remarks = cleanRemarks
            editTransaction?.amount = amount
            editTransaction?.category = category.rawValue
            editTransaction?.dateAdded = dateAdded
            editTransaction?.tintColor = tint.color
        } else {
            let transaction = TransactionModel(title: trimmedTitle, remarks: cleanRemarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            context.insert(transaction)
        }
        
        /// Dismissing View
        dismiss()
        /// Updating Widgets
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Number Formatter
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
}

private struct EntryPreview: View {
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var tint: Color

    var body: some View {
        HStack(spacing: 12) {
            Text(String(title.prefix(1)))
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 45, height: 45)
                .background(tint.gradient, in: .circle)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                Text(remarks)
                    .font(.caption)
                Text(dateAdded, format: .dateTime.day().month(.abbreviated).year())
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .lineLimit(1)
            .hSpacingForView(.leading)

            Text(amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.background, in: .rect(cornerRadius: 10))
    }
}

enum AmountText {
    static func standardize(_ raw: String) -> String {
        let decimal = Locale.current.decimalSeparator ?? "."
        var output = ""
        var hasDecimal = false
        var fractionCount = 0

        for character in raw {
            if let digit = asciiDigit(character) {
                if hasDecimal {
                    guard fractionCount < 2 else { continue }
                    fractionCount += 1
                }
                output.append(digit)
            } else if !hasDecimal, isDecimalMark(character) {
                output.append(contentsOf: decimal)
                hasDecimal = true
            }
        }

        return output
    }

    static func value(from standardized: String) -> Double {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        return formatter.number(from: standardized)?.doubleValue ?? 0
    }

    private static func asciiDigit(_ character: Character) -> Character? {
        guard let scalar = character.unicodeScalars.first, character.unicodeScalars.count == 1 else { return nil }
        switch scalar.value {
        case 0x30...0x39:
            return character
        case 0x06F0...0x06F9, 0x0660...0x0669:
            let zero: UInt32 = scalar.value <= 0x0669 ? 0x0660 : 0x06F0
            return Character(UnicodeScalar(scalar.value - zero + 0x30)!)
        default:
            return nil
        }
    }

    private static func isDecimalMark(_ character: Character) -> Bool {
        character == "." || character == "," || character == "،" || character == "٫" || character == "/"
    }
}

#Preview {
    NavigationStack {
        TransactionIncomeExpenseView()
    }
}
