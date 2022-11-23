//
//  Result+OTPVerified.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 01..
//

import Foundation

extension ResultModel {
    static func otpVerified(action: @escaping () -> Void) -> ResultModel {
        ResultModel(
            icon: .success,
            title: Strings.Localizable.registrationOtpVerifiedTitle,
            primaryAction: .init(
                title: Strings.Localizable.commonNext,
                action: { action() }
            )
        )
    }
}
