//
//  PaymentTransaction+UI.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 04. 05..
//

import Foundation

extension TransferRejection {
    var localizedString: String {
        switch self {
        case .invalidCreditor, .creditorAccountClosed:
            return Strings.Localizable.transactionRejectionInvalidAccountNumber
        case .insufficientBalance:
            return Strings.Localizable.transactionRejectionInsufficientBalance
        case .dailyLimitReached:
            return Strings.Localizable.transactionRejectionExceededLimit
        case .creditorAccountNotIntrabank:
            return Strings.Localizable.transactionRejectionNotIntrabank
        case .creditorMatchesDebtor, .invalidDebtor:
            return Strings.Localizable.transactionRejectionNotIntrabank
        case .breachTermsAndConditions:
            return Strings.Localizable.transactionRejectionGeneric
        case .invalidCreditorName, .invalidReference, .coreBankingSystemViolation, .unknown:
            return Strings.Localizable.transactionRejectionTechnicalProblem
        }
    }
}
