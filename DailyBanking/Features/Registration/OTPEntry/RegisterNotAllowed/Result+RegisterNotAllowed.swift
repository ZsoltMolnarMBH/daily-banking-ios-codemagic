//
//  Result+RegisterNotAllowed.swift
//  DailyBanking
//
//  Created by Zsombor Szabo on 2022. 05. 24..
//

import Foundation

extension ResultModel {
    static func registerNotAllowed(action: @escaping () -> Void) -> ResultModel {
        ResultModel(
            icon: .failure,
            title: Strings.Localizable.registrationStartErrorPhoneNumberNotWhitelisted,
            primaryAction: .init(
                title: Strings.Localizable.commonAllRight,
                action: { action() }
            )
        )
    }
}
