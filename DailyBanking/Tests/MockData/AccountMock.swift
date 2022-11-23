//
//  AccountMock.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 21..
//

import Foundation

@testable import DailyBanking

extension Account {
    static let mock = Mock()
    struct Mock { }
}

extension Account.Mock {
    var jasonHUF: Account {
        .init(accountId: "12345678",
              accountNumber: "123456781234567812345678",
              isLimited: false,
              isClosing: false,
              iban: "HU43123456781234567812345678",
              swift: "???",
              availableBalance: .init(value: 100000, currency: "HUF"),
              blockedBalance: .init(value: 1000, currency: "HUF"),
              bookedBalance: .init(value: 2000, currency: "HUF"),
              arrearsBalance: .init(value: 3000, currency: "HUF"),
              proxyIds: [],
              currency: "HUF",
              limits: .init(
                dailyTransferLimit: .init(
                    name: .dailyTransferLimit, value: 500000, min: 100000, max: 1000000)),
              acceptedDate: Date())
    }
}
