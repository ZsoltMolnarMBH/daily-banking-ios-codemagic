//
//  Info+TransferDate.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 28..
//

import Foundation

extension InfoScreenModel {
    static func transferDate(action: @escaping () -> Void) -> InfoScreenModel {
        InfoScreenModel(
            image: .helpNeutral,
            title: Strings.Localizable.newTransferInfoTitle,
            message: Strings.Localizable.newTransferInfoSubtitle,
            button: .init(
                text: Strings.Localizable.commonAllRight,
                style: .primary,
                action: action))
    }
}
