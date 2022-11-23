//
//  Result+ChallengeApproved.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 08. 11..
//

import Foundation

extension ResultModel {
    static func challengeApproved(action: @escaping () -> Void) -> ResultModel {
        .init(
            icon: .success,
            title: Strings.Localizable.purchaseChallengeApprovedTitle,
            subtitle: Strings.Localizable.purchaseChallengeApprovedDescription,
            primaryAction: .init(
                title: Strings.Localizable.commonAllRight,
                action: action
            )
        )
    }
}
