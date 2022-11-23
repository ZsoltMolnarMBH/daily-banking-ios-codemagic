//
//  Result+NewTransfer.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 28..
//

import Foundation

extension ResultModel {
    static func newTransferPendingNoInfo(action: @escaping () -> Void) -> ResultModel {
        ResultModel(icon: .success,
                    title: Strings.Localizable.newTransferStatePendingTitle,
                    subtitle: Strings.Localizable.newTransferResultFailedToFetchTransaction,
                    primaryAction: .init(title: Strings.Localizable.commonAllRight, action: action),
                    analyticsScreenView: "new_transfer_in_progress_no_details")
    }

    static func newTransferFailure(error: NewTransferError, action: @escaping () -> Void) -> ResultModel {
        let title = Strings.Localizable.newTransferStateRejectedTitle
        let subtitles: [String]
        let screenView: String
        switch error {
        case .rejected(let rejection):
            switch rejection {
            case .invalidCreditor, .creditorAccountClosed:
                subtitles = [Strings.Localizable.newTransferStateRejectedInvalidCreditorDescription1,
                             Strings.Localizable.newTransferStateRejectedInvalidCreditorDescription2]
                screenView = "new_transfer_error_account_invalid"
            case .insufficientBalance:
                subtitles = [Strings.Localizable.newTransferStateRejectedInsufficientBalanceDescription1,
                             Strings.Localizable.newTransferStateRejectedInsufficientBalanceDescription2]
                screenView = "new_transfer_error_insufficient_fund"
            case .dailyLimitReached:
                subtitles = [Strings.Localizable.newTransferStateRejectedLimitReachedDescription1,
                             Strings.Localizable.newTransferStateRejectedLimitReachedDescription2]
                screenView = "new_transfer_error_daily_limit"
            case .creditorAccountNotIntrabank:
                subtitles = [Strings.Localizable.newTransferStateRejectedNotIntrabankDescription1]
                screenView = "new_transfer_error_external_account"
            case .invalidCreditorName:
                subtitles = [Strings.Localizable.newTransferStateRejectedCreditorSpecialCharacter,
                             Strings.Localizable.newTransferStateRejectedPleaseRestart]
                screenView = "new_transfer_error_special_character_beneficiary"
            case .invalidReference:
                subtitles = [Strings.Localizable.newTransferStateRejectedReferenceSpecialCharacter,
                             Strings.Localizable.newTransferStateRejectedPleaseRestart]
                screenView = "new_transfer_error_special_character_comment"
            case .breachTermsAndConditions:
                subtitles = [Strings.Localizable.newTransferStateRejectedGeneric]
                screenView = "new_transfer_error_generic"
            case .invalidDebtor, .creditorMatchesDebtor, .coreBankingSystemViolation, .unknown:
                subtitles = [Strings.Localizable.newTransferStateRejectedTechnicalDescription1,
                             Strings.Localizable.newTransferStateRejectedTechnicalDescription2]
                screenView = "new_transfer_error_technical"
            }
        case .unknown:
            subtitles = [Strings.Localizable.newTransferStateRejectedTechnicalDescription1,
                         Strings.Localizable.newTransferStateRejectedTechnicalDescription2]
            screenView = "new_transfer_error_technical"
        }
        return ResultModel(icon: .failure,
                           title: title,
                           subtitles: subtitles,
                           primaryAction: .init(title: Strings.Localizable.commonAllRight, action: action),
                           analyticsScreenView: screenView)
    }
}
