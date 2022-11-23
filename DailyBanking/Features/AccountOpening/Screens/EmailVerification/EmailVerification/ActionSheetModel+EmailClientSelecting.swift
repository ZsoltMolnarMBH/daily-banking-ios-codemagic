//
//  ActionSheetModel+EmailClientSelecting.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 04..
//

import Foundation

extension ActionSheetModel {
    static func emailClientSelecting(by emailClientManager: EmailClientManaging) -> Self {
        .init(
            title: Strings.Localizable.emailVerificationEmailClientActionSheetTitle,
            items: emailClientManager.availableMailClients.map { emailClient in
                    .init(
                        title: emailClient.title,
                        iconName: emailClient.iconName) {
                            emailClientManager.launchEmailClient(emailClient)
                        }
            }
        )
    }
}
