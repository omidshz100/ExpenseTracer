//
//  CardView.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 21/12/23.
//

import SwiftUI

struct CardView: View {
    var income: Decimal
    var expense: Decimal
    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 8) {
                Text(currencyStringGenerator(income - expense, allowedDigits: 0))
                    .font(.title2.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                    .font(.body)
                    .foregroundStyle(expense > income ? .red : .green)
            }

            HStack(spacing: 0) {
                ForEach(CategoryItem.allCases, id: \.rawValue) { category in
                    let symbolImage = category == .income ? "arrow.down" : "arrow.up"
                    let tint = category == .income ? Color.green : Color.red

                    HStack(spacing: 8) {
                        Image(systemName: symbolImage)
                            .font(.caption.bold())
                            .foregroundStyle(tint)
                            .frame(width: 28, height: 28)
                            .background(tint.opacity(0.2), in: Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text(category.rawValue)
                                .font(.caption2)
                                .foregroundStyle(.gray)
                            Text(currencyStringGenerator(category == .income ? income : expense, allowedDigits: 0))
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }

                        if category == .income {
                            Spacer(minLength: 8)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(.background, in: RoundedRectangle(cornerRadius: 15))
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    ScrollView {
        CardView(income: 4590, expense: 2389)
    }
}
