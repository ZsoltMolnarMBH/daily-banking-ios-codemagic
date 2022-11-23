//
//  PinVerificationError.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 21..
//

import Foundation

enum PinVerificationError: Error {
    case invalidPin(remainingAttempts: Int)
    case forceLogout
}
