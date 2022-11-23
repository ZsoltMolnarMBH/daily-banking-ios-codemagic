//
//  Result+DocumentLoadingError.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 07. 06..
//

import DesignKit
import Foundation

extension ResultModel {
    static func documentLoadingError(action: @escaping () -> Void) -> ResultModel {
        .init(
            icon: .failure,
            title: Strings.Localizable.commonGenericErrorTitle,
            subtitle: Strings.Localizable.commonGenericErrorDescription,
            tertiaryAction: .init(
                title: Strings.Localizable.commonTryAgain,
                action: action
            ),
            analyticsScreenView: ""
        )
    }
}
