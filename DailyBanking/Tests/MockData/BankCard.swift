//
//  BankCard.swift
//  DailyBanking
//
//  Created by ALi on 2022. 07. 01..
//

import Foundation
@testable import DailyBanking

extension BankCard {
    static let mock = Mock()
    struct Mock { }
}

extension BankCard.Mock {
    func cardWithState(_ state: BankCard.State) -> BankCard {
        .init(
            cardToken: "cardToken",
            state: state,
            name: "name",
            numberLastDigits: "1234",
            cashWithdrawalLimit: .init(
                total: hufAmount(100_000),
                remaining: hufAmount(50_000),
                min: hufAmount(0),
                max: hufAmount(100_000)),
            posLimit: .init(
                total: hufAmount(100_000),
                remaining: hufAmount(50_000),
                min: hufAmount(0),
                max: hufAmount(100_000)),
            vposLimit: .init(
                total: hufAmount(100_000),
                remaining: hufAmount(50_000),
                min: hufAmount(0),
                max: hufAmount(100_000)))
    }

    private func hufAmount(_ amount: Decimal) -> Money {
        .init(value: amount, currency: "HUF")
    }
}

extension BankCardInfo {
    static let mock = Mock()
    struct Mock { }
}

extension BankCardInfo.Mock {
    var generalBankCardInfo: BankCardInfo {
        .init(cardNumber: "1234123412341234", cvc: "123", valid: "05/50", name: "name")
    }
}
