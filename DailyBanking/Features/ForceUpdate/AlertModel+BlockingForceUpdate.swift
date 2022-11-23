//
//  AlertModel+BlockingForceUpdate.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 25..
//

import Foundation

extension AlertModel {
    static func blockingForceUpdate(onUpdateRequest: @escaping () -> Void) -> AlertModel {
        AlertModel(
            title: Strings.Localizable.blockingForceUpdateTitle,
            imageName: .forbiddenSemantic,
            subtitle: Strings.Localizable.blockingForceUpdateSubtitle,
            actions: [
                .init(title: Strings.Localizable.forceUpdateAction, handler: {
                    onUpdateRequest()
                })
            ]
        )
    }
}
