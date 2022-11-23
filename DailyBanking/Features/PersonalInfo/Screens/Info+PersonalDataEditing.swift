//
//  PersonalDataEditingHelpInfoViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2021. 12. 20..
//

import Foundation
import SwiftUI

extension InfoScreenModel {
    static func personalDataEditing(action: @escaping () -> Void) -> InfoScreenModel {
        InfoScreenModel(
            image: .helpNeutral,
            title: Strings.Localizable.personalDetailsInfoTitle,
            message: Strings.Localizable.personalDetailsInfoDescription,
            button: .init(
                text: Strings.Localizable.commonHelpRequest,
                style: .primary,
                action: action))
    }
}
