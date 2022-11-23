//
//  PaymentTransactionHistoryRow.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 31..
//

import DesignKit
import SwiftUI

struct PaymentTransactionHistoryRow: View {

    let item: PaymentTransactionItemVM

    var body: some View {
        Button {
            item.action()
        } label: {
            HStack(alignment: .top, spacing: .s) {
                iconView
                VStack(alignment: .leading, spacing: 0) {
                    pair(left: AnyView(Text(item.title).textStyle(.body2)),
                         right: AnyView(amountView))
                    if let detail = item.detail {
                        switch detail {
                        case .text(let text):
                            pair(left: AnyView(Text(text).textStyle(.body3)),
                                 right: nil)
                            .foregroundColor(.text.tertiary)
                        case .fee(let fee):
                            pair(left: AnyView(Text(Strings.Localizable.transactionsTransactionFeeTitle).textStyle(.body3)),
                                 right: AnyView(Text("-" + fee).textStyle(.body3)))
                            .foregroundColor(.text.tertiary)
                        }
                    }
                    pair(left: AnyView(Text(item.subtitle).textStyle(.body3)), right: nil)
                        .foregroundColor(.text.tertiary)
                }
            }
            .padding(.horizontal, .m)
            .padding(.vertical, .s)
        }
        .buttonStyle(DesignHighlightRow())
        .background(Color.background.primary)
    }

    @ViewBuilder private func pair(left: AnyView, right: AnyView?) -> some View {
        HStack(alignment: .top, spacing: .xs) {
            left
            Spacer()
            if let right = right {
                right
            }
        }
    }

    var prefix: String {
        switch item.status {
        case .rejected:
            return ""
        case .incoming:
            return "+"
        case .outgoing:
            return "-"
        }
    }

    var iconView: some View {
        HStack(alignment: .top, spacing: 0) {
            ZStack {
                Color.background.secondary
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                Image(item.imageName)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }

    var amountView: some View {
        Text(prefix + item.amount)
            .if(item.status == .rejected) { text in
                text.strikethrough()
            }
            .foregroundColor(amountColor)
            .textStyle(.headings6)
    }

    var amountColor: Color {
        switch item.status {
        case .rejected:
            return .text.disabled
        case .incoming:
            return .success.highlight
        case .outgoing:
            return .text.primary
        }
    }
}

struct PaymentTransactionHistoryRowPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            PaymentTransactionHistoryRow.init(item: .init(
                id: UUID().uuidString,
                imageName: .giroNeutral,
                title: "Title",
                subtitle: "Subtitle",
                amount: "12700 Ft",
                detail: .fee("100 Ft"),
                status: .rejected,
                action: {})
            )
            PaymentTransactionHistoryRow.init(item: .init(
                id: UUID().uuidString,
                imageName: .giroNeutral,
                title: "Title",
                subtitle: "Subtitle",
                amount: "12700 Ft",
                detail: nil,
                status: .incoming,
                action: {})
            )
            PaymentTransactionHistoryRow.init(item: .init(
                id: UUID().uuidString,
                imageName: .giroNeutral,
                title: "Title",
                subtitle: "Subtitle",
                amount: "12700 Ft",
                detail: .text("Rejection reason"),
                status: .outgoing,
                action: {})
            )
            Spacer()
        }
        .background(Color.background.secondary)
        .preferredColorScheme(.light)

    }
}
