//
//  Result+PermamentBlocked.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 01..
//

import Foundation

extension ResultModel {
    static func permamentBlocked(action: @escaping () -> Void) -> ResultModel {
        return ResultModel(
            icon: .failure,
            title: Strings.Localizable.deviceActivationBlockedErrorTitle,
            subtitle: Strings.Localizable.deviceActivationBlockedErrorDescription,
            primaryAction: .init(
                title: Strings.Localizable.commonHelpRequest,
                action: { action() }
            )
        )
    }
}
