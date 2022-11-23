//
//  DashboardTransactionHistorySection.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 31..
//

import DesignKit
import SwiftUI

struct DashboardTransactionHistorySection: View {
    enum Model: Equatable {
        case placeholder
        case items([PaymentTransactionItemVM])
    }

    var isShimmering: Bool {
        switch model {
        case .placeholder:
            return true
        default:
            return false
        }
    }

    var isShowTitle: Bool {
        switch model {
        case .placeholder:
            return true
        case .items(let items):
            return items.count > 0
        }
    }

    let model: Model

    var body: some View {
        VStack(spacing: 0) {
            if isShowTitle {
                HStack {
                    Text(Strings.Localizable.dashboardLatestTransactions)
                        .textStyle(.headings5)
                        .foregroundColor(Color.text.secondary)
                    Spacer()
                }
                .padding(.horizontal, .m)
                .padding(.vertical, .xs)
            }
            content
        }
        .shimmeringPlaceholder(
            when: isShimmering,
            for: .background.primary
        )
    }

    @ViewBuilder
    var content: some View {
        switch model {
        case .placeholder:
            ForEach(makePlaceholderdata(count: 3)) { data in
                PaymentTransactionHistoryRow(
                    item: .init(
                        id: data.id,
                        imageName: .document,
                        title: "Placeholder title",
                        subtitle: "subtitle",
                        amount: "10 000 Ft",
                        detail: .text("Rejection"),
                        status: .outgoing,
                        action: {}
                    )
                )
            }
        case .items(let items):
            ForEach(items) { item in
                PaymentTransactionHistoryRow(item: item)
            }
        }
    }
}

struct DashboardTransactionHistorySectionPreview: PreviewProvider {
    static var previews: some View {
        DashboardTransactionHistorySection(model: .placeholder)
    }
}
