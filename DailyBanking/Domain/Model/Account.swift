//
//  Account.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 22..
//

import Foundation

struct Account {
    let accountId: String
    let accountNumber: String
    let isLimited: Bool
    let isClosing: Bool
    let iban: String
    let swift: String
    let availableBalance: Money
    let blockedBalance: Money
    let bookedBalance: Money
    let arrearsBalance: Money
    let proxyIds: [ProxyId]
    let currency: String
    var limits: AccountLimits
    var acceptedDate: Date
}
