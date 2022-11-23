//
//  Transfer.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 21..
//

import Foundation

enum TransferRejection: Equatable {
    case invalidDebtor
    case invalidCreditor
    case invalidCreditorName
    case invalidReference
    case insufficientBalance
    case dailyLimitReached
    case creditorMatchesDebtor
    case creditorAccountClosed
    case creditorAccountNotIntrabank
    case breachTermsAndConditions
    case coreBankingSystemViolation
    case unknown(String)
}
