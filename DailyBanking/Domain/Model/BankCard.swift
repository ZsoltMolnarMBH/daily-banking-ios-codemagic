//
//  CardsDraft.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 21..
//

import Foundation

struct BankCard {
    enum State {
        case active
        case frozen
        case blocked
        case transactionDBFailure
        case transactionTMLinkFailed
    }

    struct Limit {
        var total: Money
        var remaining: Money
        var min: Money
        var max: Money
    }

    let cardToken: String
    var state: State
    let name: String
    let numberLastDigits: String

    var cashWithdrawalLimit: Limit
    var posLimit: Limit
    var vposLimit: Limit
}
