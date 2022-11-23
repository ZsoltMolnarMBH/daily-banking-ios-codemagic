//
//  ChangeCardLimitMapper.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 04. 25..
//

import Foundation
import BankAPI

class ChangeCardLimitMapper: Mapper<
    (data: ChangeCardLimitMutation.Data, currency: String),
    (cash: BankCard.Limit, pos: BankCard.Limit, vpos: BankCard.Limit)
> {
    // swiftlint:disable:next large_tuple
    override func map(_ item: (data: ChangeCardLimitMutation.Data, currency: String)) throws -> (cash: BankCard.Limit, pos: BankCard.Limit, vpos: BankCard.Limit) {
        return (
            cash: item.data.changeCardLimit.cardLimits.cashWithdrawalLimit.fragments.cardLimitFragment.createLocalLimit(
                currency: item.currency
            ),
            pos: item.data.changeCardLimit.cardLimits.posLimit.fragments.cardLimitFragment.createLocalLimit(currency: item.currency),
            vpos: item.data.changeCardLimit.cardLimits.vposLimit.fragments.cardLimitFragment.createLocalLimit(currency: item.currency))
    }
}
