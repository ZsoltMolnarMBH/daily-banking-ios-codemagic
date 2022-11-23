//
//  Result+ForceLogout.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 20..
//

import Foundation

extension ResultModel {
    static func logoutForced(action: @escaping () -> Void) -> ResultModel {
        return ResultModel(
            icon: .failure,
            title: Strings.Localizable.genericAuthenticationForcedLogoutTitle,
            subtitle: Strings.Localizable.genericAuthenticationForcedLogoutSubtitle,
            primaryAction: .init(
                title: Strings.Localizable.genericAuthenticationForcedLogoutAction,
                action: { action() }
            )
        )
    }
}
