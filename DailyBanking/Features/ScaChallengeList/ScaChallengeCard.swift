//
//  ScaChallengeCard.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 06. 15..
//

import SwiftUI
import DesignKit

struct ScaChallengeCard: View {
    var item: ScaChallengeVM

    var body: some View {
        SectionCard {
            VStack(spacing: .xxs) {
                HStack {
                    Spacer()
                    Text(item.timeLeft)
                        .textStyle(.headings2.thin)
                        .foregroundColor(.text.secondary)
                    Spacer()
                }
                BankCardPlaceholderView(cardNumberLastDigits: item.lastFourDigits)
                    .frame(width: 250)
                TransactionText(title: Strings.Localizable.purchaseChallengeAmount, subtitle: item.amount)
                TransactionText(title: Strings.Localizable.purchaseChallengeMerchant, subtitle: item.merchantName)
                TransactionText(title: Strings.Localizable.purchaseChallengeDate, subtitle: item.date)
                HStack {
                    DesignButton(
                        style: .secondary,
                        size: .large,
                        title: Strings.Localizable.commonDecline
                    ) {
                        item.decline()
                    }
                    DesignButton(
                        style: .primary,
                        size: .large,
                        title: Strings.Localizable.commonApprove
                    ) {
                        item.approve()
                    }
                }
            }
        }
    }
}

private struct TransactionText: View {
    var title: String
    var subtitle: String

    var body: some View {
        HStack {
            Text(title)
                .textStyle(.body2)
            Spacer()
            Text(subtitle)
                .textStyle(.headings6)
        }
        .frame(height: 40)
    }
}

struct ScaChallengeCard_Previews: PreviewProvider {
    static var previews: some View {
        ScaChallengeCard(item: ScaChallengeVM(
            id: "",
            timeLeft: "01:24",
            lastFourDigits: "",
            amount: "",
            merchantName: "",
            date: "2012. 01. 10",
            approve: {}, decline: {}))
    }
}
