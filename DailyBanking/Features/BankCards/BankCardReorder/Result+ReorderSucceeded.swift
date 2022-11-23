//
//  Result+ReorderSucceeded.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 05. 09..
//

import DesignKit
import Foundation

extension ResultModel {
    static func reorderSucceeded(action: @escaping () -> Void) -> ResultModel {
        .init(
            icon: .image(.successSemantic),
            title: Strings.Localizable.pinSetupResultScreenTitle,
            primaryAction: .init(
                title: Strings.Localizable.commonAllRight,
                action: action
            )
        )
    }
}
