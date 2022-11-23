//
//  PhoneInfoScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2021. 12. 20..
//

import Foundation

extension InfoScreenModel {
    static func registrationPhone(action: @escaping () -> Void) -> InfoScreenModel {
        InfoScreenModel(
            image: .smartphoneRegistration,
            title: Strings.Localizable.registrationPhoneInfoSubtitle,
            message: Strings.Localizable.registrationPhoneInfoDescription,
            button: .init(
                text: Strings.Localizable.commonAllRight,
                style: .primary,
                action: action))
    }
}
