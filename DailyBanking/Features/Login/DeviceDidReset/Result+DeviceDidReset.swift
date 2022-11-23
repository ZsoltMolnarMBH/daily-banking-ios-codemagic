//
//  Result+DeviceDidReset.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 01..
//

import Foundation

extension ResultModel {
    static func deviceDidReset(action: @escaping () -> Void) -> ResultModel {
        return ResultModel(
            icon: .failure,
            title: Strings.Localizable.loginTooManyAttemptsTitle,
            subtitle: Strings.Localizable.loginTooManyAttemptsDescription,
            primaryAction: .init(
                title: Strings.Localizable.loginTooManyAttemptsButton,
                action: { action() }
            )
        )
    }
}
