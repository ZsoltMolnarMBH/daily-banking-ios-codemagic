//
//  ProxyId+UI.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 12..
//

import Foundation

extension ProxyId {
    var formattedValue: String {
        Self.formatted(value: value, using: kind)
    }

    static func formatted(value: String, using kind: Kind) -> String {
        switch kind {
        case .phoneNumber:
            return value.formatted(pattern: .phoneNumberWithCountryCode)
        default:
            return value
        }
    }
}

extension ProxyId.Kind {
    var localized: String {
        switch self {
        case .emailAddress:
            return Strings.Localizable.secondaryIdTypeEmail
        case .phoneNumber:
            return Strings.Localizable.secondaryIdTypeMobile
        case .unknown:
            return Strings.Localizable.secondaryIdTypeUnknown
        case .taxId:
            return Strings.Localizable.secondaryIdTypeTaxnr
        }
    }
}

extension ProxyId.Status {
    var localized: String {
        switch self {
        case .expired:
            return Strings.Localizable.secondaryIdStatusExpired
        case .expiresSoon:
            return Strings.Localizable.secondaryIdStatusExpireSoon
        case .activatesSoon:
            return Strings.Localizable.secondaryIdStatusPendingApproval
        case .active:
            return Strings.Localizable.secondaryIdStatusActive
        }
    }
}
