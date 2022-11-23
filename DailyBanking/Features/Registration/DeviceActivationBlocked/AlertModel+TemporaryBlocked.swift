//
//  AlertModel+TemporaryBlocked.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 01..
//

import Foundation

extension AlertModel {
    static func temporaryBlocked(time blockedTime: Int) -> AlertModel {
        AlertModel(
            title: Strings.Localizable.deviceActivationTooManyErrorTitle,
            imageName: .alertSemantic,
            subtitle: try? AttributedString(
                markdown: Strings.Localizable.deviceActivationTooManyErrorDescriptionIos(blockedTime),
                options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
            ),
            actions: [.init(title: Strings.Localizable.commonAllRight, handler: {})]
        )
    }
}
