//
//  Result+ChallengeDeclined.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 08. 11..
//

import Foundation

extension ResultModel {
    static func challengeDeclined(action: @escaping () -> Void) -> ResultModel {
        .init(
            icon: .failure,
            title: Strings.Localizable.purchaseChallengeDeclinedTitle,
            primaryAction: .init(
                title: Strings.Localizable.commonAllRight,
                action: action
            )
        )
    }
}
