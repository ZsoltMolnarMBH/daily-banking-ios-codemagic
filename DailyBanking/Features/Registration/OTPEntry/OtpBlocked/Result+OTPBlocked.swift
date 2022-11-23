//
//  Result+OTPBlocked.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 01..
//

import Foundation

extension ResultModel {
    static func otpBlocked(action: @escaping () -> Void) -> ResultModel {
        ResultModel(
            icon: .failure,
            title: Strings.Localizable.registrationOtpErrorTooManyRequestSubtitle,
            subtitle: Strings.Localizable.registrationOtpErrorTooManyRequestDescription,
            primaryAction: .init(
                title: Strings.Localizable.registrationOtpErrorRestartProcess,
                action: { action() }
            )
        )
    }
}
