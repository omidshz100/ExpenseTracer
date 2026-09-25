//
//  Recent.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//


import SwiftUI
import SwiftData
import UIKit

struct RecentTransactions: View {
    /// User Properties
    @AppStorage("userName") private var userName: String = ""
    /// View Properties
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @AppStorage("homeMonthFilter") private var savedMonth = ""
    @AppStorage("homeExtraMonths") private var extraMonthsRaw = ""
    @AppStorage("homeCategoryFilter") private var selectedCategoryRaw = CategoryItem.expense.rawValue
    @AppStorage("homeNewestFirst") private var newestFirst = true
    @Query private var transactions: [TransactionModel]
    @Environment(\.scenePhase) private var scenePhase
    @State private var today = Date()
    /// For Animation
    @Namespace private var animation
    var body: some View {
        GeometryReader {
            /// For Animation Purpose
            let size = $0.size
            
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        Section {
                            MonthFilterBar(
                                months: recentMonths,
                                selectedKey: savedMonth,
                                monthCounts: monthCounts,
                                removableKeys: Set(extraMonthKeys),
                                title: monthTitle(_:),
                                onSelect: selectMonth,
                                onPickFromCalendar: addMonthFromCalendar,
                                onRemove: removeExtraMonth
                            )
                            
                            FilterTransactionsView(startDate: startDate, endDate: endDate, newestFirst: newestFirst) { transactions in
                                /// Card View
                                CardView(
                                    income: totalCalculator(transactions, category: .income),
                                    expense: totalCalculator(transactions, category: .expense)
                                )
                                
                                HStack(spacing: 10) {
                                    CustomSegmentedControl()
                                    Button {
                                        newestFirst.toggle()
                                    } label: {
                                        VStack(spacing: 2) {
                                            Image(systemName: newestFirst ? "arrow.down" : "arrow.up")
                                                .font(.body.weight(.semibold))
                                            Text(newestFirst ? "New" : "Old")
                                                .font(.caption2.weight(.semibold))
                                        }
                                        .foregroundStyle(appTintCustom)
                                        .frame(width: 44, height: 44)
                                        .background(Color.gray.opacity(0.15), in: Circle())
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel(newestFirst ? "Newest first" : "Oldest first")
                                }
                                .padding(.bottom, 10)
                                
                                ForEach(transactions.filter({ $0.category == selectedCategoryRaw })) { transaction in
                                    NavigationLink(value: transaction) {
                                        TransactionCardView(transaction: transaction)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
                .navigationDestination(for: TransactionModel.self) { transaction in
                    TransactionIncomeExpenseView(editTransaction: transaction)
                }
            }
            .onAppear {
                today = .now
                applySavedMonth()
            }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    today = .now
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
                today = .now
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
                today = .now
            }
        }
    }

    private var monthCounts: [String: Int] {
        Dictionary(grouping: transactions, by: { monthKey($0.dateAdded) }).mapValues(\.count)
    }

    private var extraMonthKeys: [String] {
        extraMonthsRaw.split(separator: ",").map(String.init).filter { !$0.isEmpty }
    }

    private var builtinMonthKeys: Set<String> {
        let calendar = Calendar.current
        let current = today.startOfMonth
        let months = (0..<12).compactMap { calendar.date(byAdding: .month, value: -$0, to: current) }
        return Set(months.map(monthKey))
    }

    private var recentMonths: [Date] {
        let calendar = Calendar.current
        let current = today.startOfMonth
        var months = (0..<12).compactMap { calendar.date(byAdding: .month, value: -$0, to: current) }
        let known = Set(months.map(monthKey))
        for key in extraMonthKeys where !known.contains(key) {
            if let date = dateFromMonthKey(key) {
                months.append(date)
            }
        }
        return months.sorted(by: >)
    }

    private func addMonthFromCalendar(_ key: String) {
        if !builtinMonthKeys.contains(key), !extraMonthKeys.contains(key) {
            extraMonthsRaw = (extraMonthKeys + [key]).joined(separator: ",")
        }
        selectMonth(key)
    }

    private func removeExtraMonth(_ key: String) {
        extraMonthsRaw = extraMonthKeys.filter { $0 != key }.joined(separator: ",")
        if savedMonth == key {
            selectMonth(monthKey(.now))
        }
    }

    private func monthTitle(_ date: Date?) -> String {
        guard let date else { return "All" }
        return format(date: date, format: "MMM yy")
    }

    private func monthKey(_ date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return String(format: "%04d-%02d", year, month)
    }

    private func dateFromMonthKey(_ key: String) -> Date? {
        let parts = key.split(separator: "-")
        guard parts.count == 2, let year = Int(parts[0]), let month = Int(parts[1]) else { return nil }
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))
    }

    private func applySavedMonth() {
        if savedMonth.isEmpty {
            savedMonth = monthKey(.now)
        }
        selectMonth(savedMonth)
    }

    private func selectMonth(_ key: String) {
        savedMonth = key
        if key == "all" {
            startDate = .distantPast
            endDate = .distantFuture
            return
        }
        guard let month = dateFromMonthKey(key) else { return }
        startDate = month.startOfMonth
        endDate = month.endOfMonth
    }
    
    /// Header View
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5, content: {
                Text("Welcome!")
                    .font(.title.bold())
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            })
            .visualEffect { content, geometryProxy in
                content
                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
            }
            
            Spacer(minLength: 0)
            
            NavigationLink {
                TransactionIncomeExpenseView()
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(appTintCustom.gradient, in: .circle)
                    .contentShape(.circle)
            }
        }
        .padding(.bottom, userName.isEmpty ? 10 : 5)
        .background {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                Divider()
            }
            .visualEffect { content, geometryProxy in
                content
                    .opacity(headerBGOpacity(geometryProxy))
            }
            .padding(.horizontal, -15)
            .padding(.top, -(safeArea.top + 15))
        }
    }
    
    /// Segmented Control
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0) {
            ForEach(CategoryItem.allCases, id: \.rawValue) { category in
                Button {
                    withAnimation(.snappy) {
                        selectedCategoryRaw = category.rawValue
                    }
                } label: {
                    Text(category.rawValue)
                        .foregroundStyle(Color.primary)
                        .hSpacingForView()
                        .padding(.vertical, 10)
                        .background {
                            if category.rawValue == selectedCategoryRaw {
                                Capsule()
                                    .fill(.background)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .background(.gray.opacity(0.15), in: .capsule)
        .padding(.top, 5)
    }
    
    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY / 15)
    }
    
    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        
        let progress = minY / screenHeight
        let scale = (min(max(progress, 0), 1)) * 0.4
        
        return 1 + scale
    }
}

private struct MonthFilterBar: View {
    var months: [Date]
    var selectedKey: String
    var monthCounts: [String: Int]
    var removableKeys: Set<String>
    var title: (Date?) -> String
    var onSelect: (String) -> Void
    var onPickFromCalendar: (String) -> Void
    var onRemove: (String) -> Void

    @State private var showCalendar = false
    @State private var pickedDate = Date()

    var body: some View {
        ScrollViewReader { proxy in
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip("all", label: title(nil))
                    .id("all")
                Button {
                    pickedDate = Self.date(for: selectedKey) ?? .now
                    showCalendar = true
                } label: {
                    Image(systemName: "calendar")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.15), in: Capsule())
                }
                .buttonStyle(.plain)
                ForEach(months, id: \.timeIntervalSince1970) { month in
                    let key = Self.key(for: month)
                    chip(key, label: title(month))
                        .id(key)
                }
            }
        }
        .onAppear {
            proxy.scrollTo(selectedKey, anchor: .center)
        }
        .onChange(of: selectedKey) { _, key in
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(50))
                withAnimation(.snappy) {
                    proxy.scrollTo(key, anchor: .center)
                }
            }
        }
        }
        .sheet(isPresented: $showCalendar) {
            NavigationStack {
                DatePicker("Month", selection: $pickedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding()
                    .navigationTitle("Choose month")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showCalendar = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                onPickFromCalendar(Self.key(for: pickedDate))
                                showCalendar = false
                            }
                        }
                    }
            }
            .presentationDetents([.medium, .large])
        }
    }

    private func chip(_ key: String, label: String) -> some View {
        MonthChip(
            key: key,
            label: label,
            isSelected: selectedKey == key,
            count: key == "all" ? nil : monthCounts[key, default: 0],
            canRemove: removableKeys.contains(key),
            onSelect: { onSelect(key) },
            onRemove: { onRemove(key) }
        )
    }

    private static func key(for date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return String(format: "%04d-%02d", year, month)
    }

    private static func date(for key: String) -> Date? {
        let parts = key.split(separator: "-")
        guard parts.count == 2, let year = Int(parts[0]), let month = Int(parts[1]) else { return nil }
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))
    }
}

private struct MonthChip: View {
    var key: String
    var label: String
    var isSelected: Bool
    var count: Int?
    var canRemove: Bool
    var onSelect: () -> Void
    var onRemove: () -> Void
    @State private var showRemoveConfirm = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 6) {
                Text(label)
                if let count, count > 0 {
                    Text("\(count)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(isSelected ? appTintCustom : Color.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isSelected ? Color.white : appTintCustom, in: Capsule())
                }
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(isSelected ? Color.white : ((count ?? 1) > 0 ? Color.primary : Color.secondary))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                Capsule().fill(isSelected ? appTintCustom : ((count ?? 1) > 0 ? Color.gray.opacity(0.15) : Color.clear))
            }
            .overlay {
                if !isSelected, let count, count == 0 {
                    Capsule().strokeBorder(Color.secondary.opacity(0.45), lineWidth: 1)
                }
            }
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.45).onEnded { _ in
                guard canRemove else { return }
                showRemoveConfirm = true
            }
        )
        .confirmationDialog("Remove \(label)?", isPresented: $showRemoveConfirm, titleVisibility: .visible) {
            Button("Remove", role: .destructive, action: onRemove)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This month was added from the calendar.")
        }
    }
}

#Preview {
    ContentView()
}
