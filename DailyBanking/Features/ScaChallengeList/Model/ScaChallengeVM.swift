//
//  ScaChallengeVM.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 08. 10..
//

import Foundation
import BankAPI

struct ScaChallengeVM {
    let id: String
    let timeLeft: String
    let lastFourDigits: String
    let amount: String
    let merchantName: String
    let date: String

    let approve: (() -> Void)
    let decline: (() -> Void)
}
