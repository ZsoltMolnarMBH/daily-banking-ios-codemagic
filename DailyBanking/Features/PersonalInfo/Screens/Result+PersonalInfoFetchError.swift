//
//  Result+PersonalInfoFetchError.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 07..
//

import Foundation

extension ResultModel {
    static func personalInfoFetchError(action: @escaping () -> Void) -> ResultModel {
        return ResultModel(
            icon: .failure,
            title: Strings.Localizable.personalInfoFetchErrorTitle,
            subtitle: Strings.Localizable.commonPleaseRetry,
            tertiaryAction: .init(
                title: Strings.Localizable.commonRetry,
                action: { action() }
            )
        )
    }
}
