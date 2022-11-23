//
//  ProxyIdMapper.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 12..
//

import Foundation
import BankAPI

final class ProxyIdMapper: Mapper<AccountFragment.ProxyId, ProxyId> {
    override func map(_ item: AccountFragment.ProxyId) throws -> ProxyId {
        let kind: ProxyId.Kind
        switch item.type {
        case .mobNb:
            kind = .phoneNumber
        case .emailAdr:
            kind = .emailAddress
        case .othr:
            kind = .unknown
        case .__unknown:
            kind = .unknown
        }

        let status: ProxyId.Status
        switch item.status {
        case .active:
            status = .active
        case .pending:
            status = .activatesSoon
        case .deleted:
            throw makeError(item: item, reason: "Unexpected status")
        case .expired:
            status = .expired
        case .__unknown:
            throw makeError(item: item, reason: "Unexpected status")
        }

        let value = item.alias

        return ProxyId(kind: kind,
                       status: status,
                       value: value)
    }
}
