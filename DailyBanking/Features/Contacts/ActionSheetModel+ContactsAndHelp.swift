//
//  ActionSheetModel+ContactsAndHelp.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 19..
//

import Foundation
import UIKit
import DesignKit

extension ActionSheetModel {
    static let contactsAndHelp: ActionSheetModel = {
        let email = "SuperApp@magyarbankholding.hu"

        return ActionSheetModel(
            title: Strings.Localizable.commonCanWeHelp,
            items: [
                .init(title: "E-mail", subtitle: email, iconName: DesignKit.ImageName.messageUnread.rawValue, action: {
                    if let url = URL(string: "mailto:\(email)"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                })
            ])
    }()
}
