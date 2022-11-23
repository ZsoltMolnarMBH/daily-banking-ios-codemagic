//
//  Result+ProxyIdCreationSuccess.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 01..
//

import Foundation

extension ResultModel {
    static func proxyIdCreationSuccess(action: @escaping () -> Void) -> ResultModel {
        ResultModel(
            icon: .image(.stopwatchSuccess),
            title: Strings.Localizable.accountDetailsConfirmationAddPhoneTitle,
            primaryAction: .init(
                title: Strings.Localizable.commonAllRight,
                action: { action() }
            )
        )
    }
}
