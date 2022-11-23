//
//  AccountLimit.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 21..
//

import Foundation

struct AccountLimits {
    struct Limit {
        enum Name {
            case dailyTransferLimit
            case temporaryTransferLimit
        }

        let name: Name
        var value: Int
        let min: Int
        let max: Int
    }

    var dailyTransferLimit: Limit
}
