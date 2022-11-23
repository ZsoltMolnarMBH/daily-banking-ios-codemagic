//
//  Money+UI.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 02..
//

import Foundation

extension Money {

    var localizedString: String {
        return formatter.string(from: NSDecimalNumber(decimal: self.value)) ?? ""
    }

    var localizedAmount: String {
        let formatter = self.formatter
        formatter.currencySymbol = ""
        return formatter.string(from: NSDecimalNumber(decimal: self.value)) ?? ""
    }
}

extension Money {
    static func formatter(currencyCode: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode.uppercased()
        applyCurrencySpecificOptions(to: formatter, currencyCode: currencyCode)
        return formatter
    }

    static private func applyCurrencySpecificOptions(to formatter: NumberFormatter, currencyCode: String) {
        switch currencyCode.uppercased() {
        case "HUF":
            formatter.maximumFractionDigits = 0
            formatter.currencyGroupingSeparator = " "
        default:
            break
        }
    }

    var formatter: NumberFormatter {
        let formatter = Money.formatter(currencyCode: self.currency)
        applyAmountSpecificOptions(to: formatter, currencyCode: self.currency)
        return formatter
    }

    private func applyAmountSpecificOptions(to formatter: NumberFormatter, currencyCode: String) {
        let value = Double(truncating: self.value as NSNumber)
        switch value {
        case 0:
            formatter.maximumFractionDigits = 0
        default:
            break
        }
    }
}
