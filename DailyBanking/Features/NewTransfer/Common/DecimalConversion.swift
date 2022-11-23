//
//  DecimalConversion.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 24..
//

import Foundation

extension String {
    var decimalValue: Decimal {
        guard !self.isEmpty else { return Decimal(0) }
        return Decimal(string: self, locale: .current)!
    }
}

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
