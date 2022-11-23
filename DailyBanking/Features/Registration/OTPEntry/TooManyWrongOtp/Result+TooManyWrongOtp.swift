//
//  Result+TooManyWrongOtp.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 01..
//

import Foundation

extension ResultModel {
    static func tooManyWrongOtp(
        phoneNumber: String,
        primaryAction: @escaping () -> Void,
        secondaryAction: @escaping () -> Void
    ) -> ResultModel {
        ResultModel(
            icon: .failure,
            title: Strings.Localizable.registrationOtpErrorTooManyOtpTrySubtitle,
            subtitle: Strings.Localizable.registrationOtpErrorTooManyOtpTryDescription(phoneNumber),
            primaryAction: .init(
                title: Strings.Localizable.registrationOtpNewCodeRequest,
                action: { primaryAction() }
            ),
            secondaryAction: .init(
                title: Strings.Localizable.registrationOtpErrorRestartProcess,
                action: { secondaryAction() }
            )
        )
    }
}
