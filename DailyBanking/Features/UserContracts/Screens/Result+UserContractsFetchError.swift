//
//  Result+UserContractsFetchError.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 07..
//

import Foundation

extension ResultModel {
    static func userContractsFetchError(action: @escaping () -> Void) -> ResultModel {
        return ResultModel(
            icon: .failure,
            title: Strings.Localizable.contractsFetchErrorTitle,
            subtitle: Strings.Localizable.contractsFetchErrorDescription,
            tertiaryAction: .init(
                title: Strings.Localizable.contractsFetchErrorButton,
                action: { action() }
            )
        )
    }
}
