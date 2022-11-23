//
//  Result+RegisterTemporaryBlocked.swift
//  DailyBanking
//
//  Created by Zsombor Szabo on 2022. 05. 24..
//

import Foundation

extension ResultModel {
    static func registerTemporaryBlocked(
        blockedTime: Int,
        action: @escaping () -> Void
    ) -> ResultModel {
        ResultModel(
            icon: .failure,
            title: Strings.Localizable.registrationStartErrorPhoneNumberTemporaryBlocked(blockedTime/60, blockedTime%60),
            primaryAction: .init(
                title: Strings.Localizable.commonAllRight,
                action: { action() }
            )
        )
    }
}
