//
//  AlertModel+Error.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 04. 04..
//

import Foundation

extension AlertModel {
    static func networkError(_ action: (() -> Void)? = nil) -> Self {
        .init(title: Strings.Localizable.commonErrorGeneral,
              imageName: .wifiNoNeutral,
              subtitle: Strings.Localizable.commonErrorCheckNetwork,
              actions: [.init(title: Strings.Localizable.commonAllRight, handler: {
            action?()
        })])
    }

    static func genericError(_ action: (() -> Void)? = nil) -> Self {
        .init(title: Strings.Localizable.commonErrorUnexpected,
              imageName: .warningSemantic,
              subtitle: Strings.Localizable.commonGenericErrorDescription,
              actions: [.init(title: Strings.Localizable.commonAllRight, handler: {
            action?()
        })])
    }
}
