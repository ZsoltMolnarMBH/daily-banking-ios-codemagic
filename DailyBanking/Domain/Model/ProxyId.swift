//
//  ProxyId.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 11..
//

import Foundation

struct ProxyId {
    let kind: Kind
    enum Kind: String {
        case emailAddress
        case phoneNumber
        case taxId
        case unknown
    }
    let status: Status
    enum Status {
        case expired
        case expiresSoon
        case activatesSoon
        case active
    }
    let value: String
}

extension ProxyId.Kind: CaseIterable { }
