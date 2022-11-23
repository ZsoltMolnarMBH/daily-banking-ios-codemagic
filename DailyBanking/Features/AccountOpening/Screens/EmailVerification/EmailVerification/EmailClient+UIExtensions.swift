//
//  EmailClientChecker+UIExtensions.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 02..
//

import Foundation

extension EmailClient {

    var title: String {
        switch self {
        case .native:
            return Strings.Localizable.emailClientNative
        case .gmail:
            return Strings.Localizable.emailClientGmail
        case .outlook:
            return Strings.Localizable.emailClientOutlook
        case .spark:
            return Strings.Localizable.emailClientSpark
        }
    }

    var iconName: String {
        switch self {
        case .native:
            return ImageName.mailappIcon.rawValue
        case .gmail:
            return ImageName.gmailIcon.rawValue
        case .outlook:
            return ImageName.outlookIcon.rawValue
        case .spark:
            return ImageName.sparkIcon.rawValue
        }
    }
}
