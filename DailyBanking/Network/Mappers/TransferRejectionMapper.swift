//
//  NewTransferRejectionMapper.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 07..
//

import Foundation
import BankAPI

class TransferRejectionMapper: Mapper<RejectionReason, TransferRejection> {
    override func map(_ item: RejectionReason) throws -> TransferRejection {
        switch item {
        case .invalidCreditorIban:
            return .invalidCreditor
        case .invalidDebtorIban:
            return .invalidDebtor
        case .invalidCreditorBban:
            return .invalidCreditor
        case .invalidDebtorBban:
            return .invalidDebtor
        case .noBalanceCoverage:
            return .insufficientBalance
        case .creditorAndDebtorIdentificationsAreTheSame:
            return .creditorMatchesDebtor
        case .creditorAccountNotIntrabank:
            return .creditorAccountNotIntrabank
        case .creditorAccountClosed:
            return .creditorAccountClosed
        case .dailyLimitReached:
            return .dailyLimitReached
        case .invalidReference:
            return .invalidReference
        case .invalidCreditorName:
            return .invalidCreditorName
        case .breachTermsAndConditions:
            return .breachTermsAndConditions
        case .coreBankingSystemViolation:
            return .coreBankingSystemViolation
        case .__unknown(let rawValue):
            return .unknown(rawValue)
        }
    }
}
