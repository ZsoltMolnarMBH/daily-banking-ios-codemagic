//
//  ScaChallengeListMapper.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 07. 26..
//

import BankAPI
import Foundation

class ScaChallengeListMapper: Mapper<[ScaChallengeFragment], [ScaChallenge]> {
    override func map(_ item: [ScaChallengeFragment]) throws -> [ScaChallenge] {

        return item.compactMap {
            ScaChallenge(
                id: $0.id,
                userId: $0.userId,
                cardToken: $0.cardToken,
                merchantName: $0.merchant,
                amount: Money(value: $0.amount.decimalValue, currency: $0.currency),
                challengedAtDate: BankAPI.dateFormatter.date(from: $0.challengedAt) ?? Date(),
                expiresAfter: $0.expiresAfter,
                lastDigits: $0.lastDigits
            )
        }
    }
}
