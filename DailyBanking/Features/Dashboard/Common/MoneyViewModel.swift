//
//  MoneyViewModel.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2021. 12. 20..
//

import Foundation

struct CurrencyViewModel {
    let symbol: String
    let isPrefix: Bool
}

extension CurrencyViewModel {
    var isSuffix: Bool {
        !isPrefix
    }
}

struct MoneyViewModel {
    let amount: String
    let currency: CurrencyViewModel
}

extension MoneyViewModel {
    static let zeroHUF = MoneyViewModel(amount: "0", currency: .init(symbol: "Ft", isPrefix: false))
}

extension MoneyViewModel {
    static func make(using money: Money) -> MoneyViewModel {
        money.formatter
            .moneyViewModel(from: money.value)
    }
}

extension CurrencyViewModel {
    static func make(currencyCode: String) -> CurrencyViewModel {
        let dummyValue: Decimal = 1
        let money = Money(value: dummyValue, currency: currencyCode)
        return money.formatter
            .moneyViewModel(from: dummyValue)
            .currency
    }
}

extension NumberFormatter {
    func moneyViewModel(from value: Decimal) -> MoneyViewModel {
        let string = string(from: NSDecimalNumber(decimal: value))!
        let symbol = currencySymbol!
        let isPrefix = string.hasPrefix(symbol)
        let amount: String
        if isPrefix {
            amount = String(string.dropFirst(symbol.count))
        } else {
            amount = String(string.dropLast(symbol.count))
        }
        return MoneyViewModel(amount: amount, currency: .init(symbol: symbol, isPrefix: isPrefix))
    }
}
