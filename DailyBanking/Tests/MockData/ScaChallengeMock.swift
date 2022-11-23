//
//  ScaChallengeMock.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 08. 12..
//

import Foundation
import BankAPI

extension GetScaChallengeListQuery.Data {
    static let mock = Mock()
    struct Mock { }
}

extension GetScaChallengeListQuery.Data.Mock {
    func result() -> GetScaChallengeListQuery.Data {

        let scaChallengeList = GetScaChallengeListQuery.Data.GetScaChallengeList(
            id: "123",
            userId: "321",
            cardToken: "4567",
            merchant: "Test Merchant",
            amount: "140050",
            currency: "HUF",
            challengedAt: "",
            expiresAfter: 600,
            status: ScaChallengeStatus.pending,
            lastDigits: "0126")

        return GetScaChallengeListQuery.Data.init(getScaChallengeList: [scaChallengeList])
    }
}
