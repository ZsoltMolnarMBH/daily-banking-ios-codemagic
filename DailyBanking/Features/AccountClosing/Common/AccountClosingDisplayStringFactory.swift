//
//  AccountClosingDisplayStringFactory.swift
//  DailyBanking
//
//  Created by ALi on 2022. 06. 10..
//

import Foundation
import Resolver

class AccountClosingDisplayStringFactory {

    @Injected var account: ReadOnly<Account?>

    var isAccountOpenedWithin14days: Bool {
        guard let acceptedDate = account.value?.acceptedDate else {
            return true
        }

        return acceptedDate.isWithin14days
    }

    var statementViewerTitle: String {
        if isAccountOpenedWithin14days {
            return Strings.Localizable.accountClosingWithdrawalStatementPreviewCancellationTitle
        }

        return Strings.Localizable.accountClosingWithdrawalStatementPreviewTerminationTitle
    }

    var signingScreenTitle: String {
        if isAccountOpenedWithin14days {
            return Strings.Localizable.accountClosingWithdrawalCancellationTitle
        }

        return Strings.Localizable.accountClosingWithdrawalTerminationTitle
    }

    var signingScreenText1: String {
        if isAccountOpenedWithin14days {
            return Strings.Localizable.accountClosingWithdrawalCancellationText1
        }

        return Strings.Localizable.accountClosingWithdrawalTerminationText1
    }

    var signingScreenText2: String {
        if isAccountOpenedWithin14days {
            return Strings.Localizable.accountClosingWithdrawalCancellationText2
        }

        return Strings.Localizable.accountClosingWithdrawalTerminationText2
    }
}
