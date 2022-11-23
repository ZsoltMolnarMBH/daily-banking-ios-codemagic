//
//  Result+MonthlyStatementsFetchError.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 07..
//

import Foundation

extension ResultModel {
    static func monthlyStatementsFetchError(action: @escaping () -> Void) -> ResultModel {
        return ResultModel(
            icon: .failure,
            title: Strings.Localizable.monthlyStatementFetchErrorTitle,
            subtitle: Strings.Localizable.commonPleaseRetry,
            tertiaryAction: .init(
                title: Strings.Localizable.commonTryAgain,
                action: { action() }
            )
        )
    }
}
