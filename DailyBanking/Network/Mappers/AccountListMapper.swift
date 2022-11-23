//
//  AccountListMapper.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 22..
//

import BankAPI
import Foundation
import Resolver

class AccountListMapper: Mapper<AccountFragment, Account> {

    @Injected var proxyIdMapper: Mapper<AccountFragment.ProxyId, ProxyId>

    override func map(_ item: AccountFragment) throws -> Account {
        guard let acceptedDate = BankAPI.dateFormatters.date(from: item.acceptedDate) else {
            throw makeError(item: item, reason: "invalid date format at: .acceptedDate")
        }

        return .init(
            accountId: item.accountId,
            accountNumber: item.accountNumber,
            isLimited: item.flags.contains(where: { $0 == .limitedAccount }),
            isClosing: item.flags.contains(where: { $0 == .accountClosing }),
            iban: item.iban,
            swift: item.swift,
            availableBalance: convertMoney(from: item.availableBalance.fragments.balanceFragment),
            blockedBalance: convertMoney(from: item.blockedBalance.fragments.balanceFragment),
            bookedBalance: convertMoney(from: item.bookedBalance.fragments.balanceFragment),
            arrearsBalance: convertMoney(from: item.arrearsBalance.fragments.balanceFragment),
            proxyIds: proxyIdMapper.compactMap(item.proxyIds),
            currency: item.currency,
            limits: convertLimits(from: item.limits),
            acceptedDate: acceptedDate
        )
    }

    private func convertMoney(from balance: BalanceFragment) -> Money {
        Money(value: .init(balance.netAmount), currency: balance.currency)
    }

    private func convertLimits(from limits: AccountFragment.Limit) -> AccountLimits {
        return .init(
            dailyTransferLimit: .init(
                name: convertLimitName(from: limits.dailyTransferLimit.name),
                value: limits.dailyTransferLimit.value,
                min: limits.dailyTransferLimit.min,
                max: limits.dailyTransferLimit.max)
        )
    }

    private func convertLimitName(from limitType: LimitType) -> AccountLimits.Limit.Name {
        switch limitType {
        case .dailyTransferLimit:
            return .dailyTransferLimit
        case .temporaryTransferLimit:
            return .temporaryTransferLimit
        case .__unknown:
            return .dailyTransferLimit
        }
    }

    static func convertLimitName(from limitName: AccountLimits.Limit.Name) -> LimitType {
        switch limitName {
        case .dailyTransferLimit:
            return .dailyTransferLimit
        case .temporaryTransferLimit:
            return .temporaryTransferLimit
        }
    }
}
