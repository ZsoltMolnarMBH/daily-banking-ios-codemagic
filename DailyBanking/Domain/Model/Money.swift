//
//  Money.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 25..
//

import Foundation

struct Money {
    let value: Decimal
    let currency: String
}

extension Money: Equatable { }

extension Money {
    static let zeroHUF = Money(value: 0, currency: "HUF")
}
