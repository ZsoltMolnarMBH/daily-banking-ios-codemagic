//
//  AlertModel+BankCardBlockSuccess.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 23..
//

import Foundation

extension AlertModel {
    static func bankCardBlockSuccess(primaryAction: @escaping () -> Void, skipAction: @escaping () -> Void) -> AlertModel {
        AlertModel(
            title: Strings.Localizable.bankCardBlockResultScreenSuccessTitle,
            imageName: .successSemantic,
            subtitle: Strings.Localizable.blockBankCardResultScreenSuccessDescription,
            actions: [
                .init(title: Strings.Localizable.commonSkip, kind: .secondary, handler: { skipAction() }),
                .init(title: Strings.Localizable.bankCardBlockResultScreenButton, handler: { primaryAction() })

            ]
        )
    }
}
