//
//  Result+GenericError.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 06..
//

import DesignKit
import Foundation

extension ResultModel {
    static func genericError(screenName: String, action: @escaping () -> Void) -> ResultModel {
        .init(
            icon: .failure,
            title: Strings.Localizable.commonGenericErrorTitle,
            subtitle: Strings.Localizable.commonGenericErrorDescription,
            primaryAction: .init(
                title: Strings.Localizable.commonTryAgain,
                action: action
            ),
            analyticsScreenView: screenName
        )
    }
}
