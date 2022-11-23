//
//  Result+RegistrationSuccess.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 01..
//

import Foundation

extension ResultModel {
    static func registrationSuccess(action: @escaping () -> Void) -> ResultModel {
        ResultModel(
            icon: .success,
            title: Strings.Localizable.registrationFinishTitle,
            subtitle: Strings.Localizable.registrationFinishDescription,
            primaryAction: .init(
                title: Strings.Localizable.registrationFinishButton,
                action: { action() }
            )
        )
    }
}
