//
//  EmailInfoScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2021. 12. 20..
//

import Foundation

extension InfoScreenModel {
    static func registrationEmail(action: @escaping () -> Void) -> InfoScreenModel {
        InfoScreenModel(
            image: .emailNeutral,
            title: Strings.Localizable.registrationEmailInfoSubtitle,
            message: Strings.Localizable.registrationEmailInfoDescription,
            button: .init(
                text: Strings.Localizable.commonAllRight,
                style: .primary,
                action: action))
    }
}
