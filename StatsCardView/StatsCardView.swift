//
//  StatsCardView.swift
//  StatsCardView
//
//  Created by Omid Shojaeian Zanjani on 08/04/24.
//


import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: .now, income: Decimal(2400), expense: Decimal(860))
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        completion(context.isPreview ? placeholder(in: context) : WidgetEntry.current())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> ()) {
        let summary = WidgetEntry.current()
        let start = Date()
        var entries: [WidgetEntry] = []

        if summary.income > 0 {
            let frameCount = 18
            let duration = 0.9
            entries += (0..<frameCount).map { index in
                let t = Double(index) / Double(frameCount - 1)
                let eased = 1 - pow(1 - t, 3)
                return WidgetEntry(
                    date: start.addingTimeInterval(duration * t),
                    income: summary.income,
                    expense: summary.expense,
                    shown: eased,
                    phase: 0
                )
            }
        }

        let ambientStart = start.addingTimeInterval(summary.income > 0 ? 1 : 0)
        let frameCount = 150
        let step: TimeInterval = 2
        entries += (0..<frameCount).map { index in
            let phase = Double(index) / Double(frameCount) * 2 * Double.pi
            return WidgetEntry(
                date: ambientStart.addingTimeInterval(step * Double(index)),
                income: summary.income,
                expense: summary.expense,
                shown: 1,
                phase: phase
            )
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let income: Decimal
    let expense: Decimal
    /// 0...1, how far the bar and percent have drawn in.
    var shown: Double = 1
    /// Radians, drives the slow background drift.
    var phase: Double = 0

    static func current() -> WidgetEntry {
        let now = Date.now
        let start = now.startOfMonth
        let end = now.endOfMonth
        let context = ModelContext(SharedModelContainer.shared)
        let descriptor = FetchDescriptor<TransactionModel>(
            predicate: #Predicate { transaction in
                transaction.dateAdded >= start && transaction.dateAdded <= end
            }
        )
        let transactions = (try? context.fetch(descriptor)) ?? []
        let income = transactions
            .filter { $0.category == CategoryItem.income.rawValue }
            .reduce(Decimal.zero) { $0 + $1.money }
        let expense = transactions
            .filter { $0.category == CategoryItem.expense.rawValue }
            .reduce(Decimal.zero) { $0 + $1.money }
        return WidgetEntry(date: now, income: income, expense: expense)
    }
}

struct StatsCardViewEntryView: View {
    var entry: WidgetEntry

    private var isEmpty: Bool { entry.income == 0 && entry.expense == 0 }
    private var spentRatio: Double {
        guard entry.income > 0 else { return 0 }
        return NSDecimalNumber(decimal: entry.expense / entry.income).doubleValue
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(entry.date.formatted(.dateTime.month(.wide).year()), systemImage: "calendar")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            if isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "tray")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    Text("Nothing recorded yet")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            } else {
                HStack(spacing: 8) {
                    amountPill(title: "Income", value: entry.income, tint: .green, symbol: "arrow.down")
                    amountPill(title: "Expense", value: entry.expense, tint: .red, symbol: "arrow.up")
                }
                spentBar
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }

    private var spentBar: some View {
        VStack(alignment: .leading, spacing: 4) {
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.primary.opacity(0.08))
                    Capsule()
                        .fill(Color.red.gradient)
                        .frame(width: proxy.size.width * min(spentRatio, 1) * entry.shown)
                }
            }
            .frame(height: 6)
            Group {
                if entry.income <= 0 {
                    Text("No income this month")
                } else {
                    HStack(spacing: 3) {
                        Text("\(spentPercent)")
                            .contentTransition(.numericText())
                        Text("% of income spent")
                    }
                }
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }

    private var spentPercent: Int {
        Int((spentRatio * entry.shown * 100).rounded())
    }

    private func amountPill(title: String, value: Decimal, tint: Color, symbol: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.caption.bold())
                .foregroundStyle(tint)
                .frame(width: 26, height: 26)
                .background(tint.opacity(0.16), in: Circle())
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(currencyStringGenerator(value, allowedDigits: 0))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .contentTransition(.numericText())
            }
            Spacer(minLength: 0)
        }
    }
}

struct WidgetBackdrop: View {
    var phase: Double

    var body: some View {
        let drift = (sin(phase) + 1) / 2
        ZStack {
            Color(.systemBackground)
            Circle()
                .fill(Color.green.opacity(0.20 + drift * 0.08))
                .frame(width: 180, height: 180)
                .blur(radius: 42)
                .offset(x: -90 + drift * 70, y: -48 + drift * 18)
            Circle()
                .fill(Color.red.opacity(0.12 + (1 - drift) * 0.10))
                .frame(width: 190, height: 190)
                .blur(radius: 46)
                .offset(x: 100 - drift * 64, y: 36 - drift * 16)
        }
    }
}

struct StatsCardView: Widget {
    let kind: String = "StatsCardView"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StatsCardViewEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    WidgetBackdrop(phase: entry.phase)
                }
        }
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
        .configurationDisplayName("Monthly Summary")
        .description("This month's income, expense, and how much of the income was spent.")
    }
}

#Preview(as: .systemMedium) {
    StatsCardView()
} timeline: {
    WidgetEntry(date: .now, income: Decimal(2400), expense: Decimal(860))
}
