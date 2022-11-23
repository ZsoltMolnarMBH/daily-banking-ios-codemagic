//
//  MoneyMapper.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 08. 25..
//

import BankAPI

class MoneyMapper: Mapper<MoneyFragment, Money> {
    override func map(_ item: MoneyFragment) throws -> Money {
        guard let amount = Decimal(string: item.amount) else {
            throw makeError(item: item, reason: "Amount can not be converted to Decimal")
        }
        let currency = item.currencyCode.uppercased()
        return Money(value: amount, currency: currency)
    }
}
