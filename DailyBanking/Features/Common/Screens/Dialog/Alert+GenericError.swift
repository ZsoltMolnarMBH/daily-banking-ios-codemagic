//
//  Alert+GenericError.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 06. 24..
//

import Foundation

extension AlertModel {
    static func genericError(onRetry: @escaping () -> Void) -> AlertModel {
        let cancel = AlertModel.Action(title: Strings.Localizable.commonCancel, kind: .secondary, handler: { })
        let retry = AlertModel.Action(title: Strings.Localizable.commonRetry, handler: { onRetry() })
        return AlertModel(
            title: Strings.Localizable.commonGenericErrorTitle,
            imageName: .alertSemantic,
            subtitle: Strings.Localizable.commonGenericErrorDescription,
            actions: [cancel, retry]
        )
    }
}
