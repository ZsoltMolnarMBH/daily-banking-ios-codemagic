//
//  ClosureFeedbackCode+.swift
//  DailyBanking
//
//  Created by ALi on 2022. 06. 07..
//

import Foundation
import BankAPI

extension ClosureFeedbackCode {
    init(from reason: AccountClosingDraft.Reason) {
        switch reason {
        case .tooExpensive:
            self = .tooExpensive
        case .dissatisfied:
            self = .dissatisfied
        case .foundBetter:
            self = .betterAlternaitve
        case .badSupport:
            self = .poorSupport
        }
    }
}
