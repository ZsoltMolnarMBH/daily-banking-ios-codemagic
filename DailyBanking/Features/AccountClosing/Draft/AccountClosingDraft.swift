//
//  AccountClosingDraft.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 18..
//

import Foundation
import BankAPI

struct AccountClosingDraft {

    enum Reason: CaseIterable {
        case tooExpensive
        case dissatisfied
        case foundBetter
        case badSupport
    }

    var reason: Reason?
    var comment: String?
    var transferAccount: String?
    var withdrawalStatementContractId: String?
}

extension AccountClosingDraft.Reason {

    var displayString: String {
        switch self {
        case .tooExpensive:
            return Strings.Localizable.accountClosingReasonTooExpensive
        case .dissatisfied:
            return Strings.Localizable.accountClosingReasonDissatisfied
        case .foundBetter:
            return Strings.Localizable.accountClosingReasonFoundBetter
        case .badSupport:
            return Strings.Localizable.accountClosingReasonBadSupport
        }
    }
}
