//
//  AlertModel+ForegroundWarning.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 04..
//

import Foundation

extension AlertModel {
    static var foregroundWarning: AlertModel {
        return AlertModel(
            imageName: .stopwatchNeutral,
            subtitle: AttributedString(Strings.Localizable.foregroundSessionExpiringSoonDescription),
            actions: [
                .init(title: Strings.Localizable.commonContinue, handler: {})
            ])
    }
}
