//
//  AlertModel+biometryLocked.swift
//  DailyBanking
//
//  Created by ALi on 2022. 06. 17..
//

import Foundation

extension AlertModel {
    static let biometryLockedAlert: AlertModel = .init(
        title: Strings.Localizable.biometryLockedAlertTitle,
        subtitle: Strings.Localizable.biometryLockedAlertText,
        actions: [
            .init(title: Strings.Localizable.commonAllRight, handler: { })
        ])
}
