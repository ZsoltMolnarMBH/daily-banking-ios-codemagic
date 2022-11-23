//
//  LimitMapper.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 04. 29..
//

import Foundation
import BankAPI

class LimitMapper: Mapper<(currency: String, data: CardLimitFragment), BankCard.Limit> {
    override func map(_ item: (currency: String, data: CardLimitFragment)) throws -> BankCard.Limit {
        return BankCard.Limit(
            total: Money(value: Decimal(item.data.total), currency: item.currency),
            remaining: Money(value: Decimal(item.data.remaining), currency: item.currency),
            min: Money(value: Decimal(item.data.min), currency: item.currency),
            max: Money(value: Decimal(item.data.max), currency: item.currency)
        )
    }
}
