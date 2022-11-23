//
//  Info+UnavailableFeature.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 06. 21..
//

import Foundation

extension InfoScreenModel {
    static func unavailableFeature(message: String, action: @escaping () -> Void) -> InfoScreenModel {
        .init(image: .functionLock,
              title: Strings.Localizable.commonNotAvailableYet,
              message: message,
              button: .init(
                text: Strings.Localizable.commonAllRight,
                style: .primary,
                action: action))
    }
}
