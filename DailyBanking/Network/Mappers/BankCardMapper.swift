//
//  BankCardMapper.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 26..
//

import Foundation
import BankAPI
import Resolver

class BankCardMapper: Mapper<(data: CardsGetQuery.Data, currency: String), [BankCard]> {

    @Injected var limitMapper: Mapper<(currency: String, data: CardLimitFragment), BankCard.Limit>

    override func map(_ item: (data: CardsGetQuery.Data, currency: String)) throws -> [BankCard] {

        return try item.data.cardsGet.map {

            let cashWithdrawalLimit = try limitMapper.map((
                currency: item.currency,
                data: $0.limits.cashWithdrawalLimit.fragments.cardLimitFragment))
            let posLimit = try limitMapper.map((
                currency: item.currency,
                data: $0.limits.posLimit.fragments.cardLimitFragment))

            let vposLimit = try limitMapper.map((
                currency: item.currency,
                data: $0.limits.vposLimit.fragments.cardLimitFragment))

            var cardState = convertState(from: $0.status)

            if $0.reordered {
                cardState = .transactionDBFailure
            } else if !$0.cardErrors.filter({ $0.fragments.userTransactionErrorFragment.error == "TM_LINK_FAILED" }).isEmpty {
                cardState = .transactionTMLinkFailed
            }

            return BankCard(
                cardToken: $0.cardToken,
                state: cardState,
                name: $0.nameOnCard,
                numberLastDigits: $0.lastNumbers,
                cashWithdrawalLimit: cashWithdrawalLimit,
                posLimit: posLimit,
                vposLimit: vposLimit
            )
        }
    }

    private func getBankCardLimit(data: CardsGetQuery.Data.CardsGet.Limit, currency: String) -> BankCard.Limit {

        return data.cashWithdrawalLimit.fragments.cardLimitFragment.createLocalLimit(currency: currency)
    }

    private func convertState(from state: String) -> BankCard.State {
        // State should be an enum in graphQL schema - https://mkb-sys.atlassian.net/browse/DB-1506
        switch state {
        case "FROZEN":
            return .frozen
        case "FULLY_OPERATIONAL":
            return .active
        case "BLOCKED":
            return .blocked
        default:
            return .active
        }
    }

    static func convertState(from state: BankCard.State) -> String {
        // State should be an enum in graphQL schema https://mkb-sys.atlassian.net/browse/DB-1506
        switch state {
        case .frozen:
            return "FROZEN"
        case .active:
            return "FULLY_OPERATIONAL"
        case .blocked, .transactionDBFailure, .transactionTMLinkFailed:
            return "BLOCKED"
        }
    }

    private func convertState(from state: CardStatus) -> BankCard.State {
        // State should be an enum in graphQL schema - https://mkb-sys.atlassian.net/browse/DB-1506
        switch state {
        case .frozen:
            return .frozen
        case .fullyOperational:
            return .active
        case .blocked:
            return .blocked
        default:
            return .active
        }
    }

    static func convertState(from state: BankCard.State) -> CardStatus {
        // State should be an enum in graphQL schema https://mkb-sys.atlassian.net/browse/DB-1506
        switch state {
        case .frozen:
            return .frozen
        case .active:
            return .fullyOperational
        case .blocked, .transactionDBFailure, .transactionTMLinkFailed:
            return .blocked
        }
    }
}
