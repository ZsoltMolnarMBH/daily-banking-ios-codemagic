//
//  ScaChallenge.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 07. 27..
//

import Foundation

struct ScaChallenge {

    var id: String
    var userId: String
    var cardToken: String
    var merchantName: String
    var amount: Money
    var challengedAtDate: Date
    var expiresAfter: Double
    var lastDigits: String
}
