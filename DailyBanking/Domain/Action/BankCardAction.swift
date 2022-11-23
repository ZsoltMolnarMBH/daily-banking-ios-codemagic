//
//  BankCardAction.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 26..
//

import Foundation
import Resolver
import BankAPI
import Combine
import SwiftUI

extension CardLimitFragment {

    func createLocalLimit(currency: String) -> BankCard.Limit {
        return BankCard.Limit(
            total: Money(value: Decimal(total), currency: currency),
            remaining: Money(value: Decimal(remaining), currency: currency),
            min: Money(value: Decimal(min), currency: currency),
            max: Money(value: Decimal(max), currency: currency)
        )
    }
}

protocol BankCardAction {
    func requestBankCard() -> AnyPublisher<Never, AnyActionError>
    func changeBankCardLimit(cashWithdrawal: Double?, pos: Double?, vpos: Double?) -> AnyPublisher<Never, AnyActionError>
    func setCardState(state: BankCard.State, cardToken: String) -> AnyPublisher<Never, AnyActionError>
    func requestBankCardInfo(cardToken: String) -> AnyPublisher<Never, AnyActionError>
    func requestBankCardPin(cardToken: String) -> AnyPublisher<Never, AnyActionError>
    func reorderCard(pinCode: String) -> AnyPublisher<Never, ActionError<BankCardReorderError>>
}

enum BankCardReorderError: Error {
    case transactionRenewalFailed
    case transactionDBFailure
    case transactionSetPinFailed
    case transactionGetPanFailed
    case transactionDBFailureAndSetPinFailed
    case transactionTMLinkFailed
    case transactionTMLinkFailedAndSetPinFailed
}

enum BankCardError: Error {
    case transactionStatusPending
    case transactionStatusError
}

class BankCardActionImpl: BankCardAction {

    @Injected private var api: APIProtocol
    @Injected private var bankCardStore: any BankCardStore
    @Injected private var bankCardInfoStore: any BankCardInfoStore
    @Injected private var bankCardPinStore: any BankCardPinStore
    @Injected private var accountStore: any AccountStore
    @Injected private var responseMapperCards: Mapper<(data: CardsGetQuery.Data, currency: String), [BankCard]>
    // swiftlint:disable:next large_tuple
    @Injected private var responseMapperChangeCardLimit: Mapper<
        (data: ChangeCardLimitMutation.Data, currency: String),
        (cash: BankCard.Limit, pos: BankCard.Limit, vpos: BankCard.Limit)
    >
    @Injected private var responseMapperCardInfo: Mapper<(
        data: CardDetailsQuery.Data.CardDetail,
        key: [UInt8]
    ), BankCardInfo>
    @Injected private var responseMapperCardPin: Mapper<(data: CardPinQuery.Data, key: [UInt8]), String?>
    @Injected private var cipher: BankCardCipher

    func requestBankCard() -> AnyPublisher<Never, AnyActionError> {
        cardsGetQuery().mapAnyActionError()
    }

    private func cardsGetQuery() -> AnyPublisher<Never, Error> {
        let accountId = accountStore.state.value?.accountId ?? ""
        let currency = accountStore.state.value?.currency ?? "HUF"
        return api.publisher(for: CardsGetQuery(accountId: accountId), cachePolicy: .fetchIgnoringCacheCompletely)
            .tryMap { [responseMapperCards] response -> BankCard? in
                try responseMapperCards.map((data: response, currency: currency)).first
            }
            .compactMap { $0 }
            .map { [bankCardStore] bankCard in
                bankCardStore.modify { $0 = bankCard }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func changeBankCardLimit(cashWithdrawal: Double?, pos: Double?, vpos: Double?) -> AnyPublisher<Never, AnyActionError> {
        let cardToken = bankCardStore.state.value?.cardToken ?? ""
        let currency = accountStore.state.value?.currency ?? "HUF"

        var limits = [ChangeCardLimitInput]()

        if let cashWithdrawal = cashWithdrawal {
            limits.append(ChangeCardLimitInput(amount: cashWithdrawal, limitType: .cashWithdrawalDaily))
        }

        if let pos = pos {
            limits.append(ChangeCardLimitInput(amount: pos, limitType: .posDaily))
        }

        if let vpos = vpos {
            limits.append(ChangeCardLimitInput(amount: vpos, limitType: .vposDaily))
        }

        return api.publisher(for: ChangeCardLimitMutation(limits: limits, cardToken: cardToken))
            .tryMap { [responseMapperChangeCardLimit] response -> (cash: BankCard.Limit, pos: BankCard.Limit, vpos: BankCard.Limit) in
                try responseMapperChangeCardLimit.map((data: response, currency: currency))
            }
            .map { [bankCardStore] bankCardLimit in
                bankCardStore.modify {
                    $0?.cashWithdrawalLimit = bankCardLimit.cash
                    $0?.posLimit = bankCardLimit.pos
                    $0?.vposLimit = bankCardLimit.vpos
                }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func reorderCard(pinCode: String) -> AnyPublisher<Never, ActionError<BankCardReorderError>> {
        let cardToken = bankCardStore.state.value?.cardToken ?? ""

        return Just(cardToken)
            .tryMap { cardToken -> ReorderCardMutation in
                let sessionKey = cipher.randomSessionKey()
                let encryptedSessionKeyBase64 = try cipher.encryptSessionKeyRSA(sessionKey)
                let encryptedPinCode = try cipher.encryptPinCode(pinCode: pinCode, sessionKey: sessionKey)
                let epin = Epin(pin: encryptedPinCode.0, iv: encryptedPinCode.1)
                return ReorderCardMutation(cardToken: cardToken, encryptedKey: encryptedSessionKeyBase64, epin: epin)
            }
            .flatMap { [api] query in
                api.publisher(for: query)
            }
            .map { $0.reorderCard.transactionId }
            .withUnretained(self)
            .flatMap { action, transactionId -> AnyPublisher<Bool, Error> in
                action.pollTransaction(transactionId: transactionId)
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: BankCardReorderError.self)
    }

    func setCardState(state: BankCard.State, cardToken: String) -> AnyPublisher<Never, AnyActionError> {
        return api.publisher(for: SetCardStatusMutation(cardStatus: BankCardMapper.convertState(from: state), cardToken: cardToken))
            .map { $0.setCardStatus.transactionId }
            .withUnretained(self)
            .flatMap { action, transactionId -> AnyPublisher<Bool, Error> in
                action.pollTransaction(transactionId: transactionId)
            }
            .handleEvents(receiveOutput: { [bankCardStore] _ in
                bankCardStore.modify {
                    $0?.state = state
                }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    enum BankCardError: Error {
        case transactionStatusPending
        case transactionStatusError
        case unkown
    }

    private func pollTransaction(transactionId: String) -> AnyPublisher<Bool, Error> {
        return api.publisher(for: GetCardTransactionStatusQuery(transactionId: transactionId), cachePolicy: .fetchIgnoringCacheCompletely)
            .tryMap { response -> Bool in

                let status = response.getCardTransactionStatus.result
                let errors = response.getCardTransactionStatus.error?.map {
                    $0.fragments.userTransactionErrorFragment.error
                }.compactMap { $0 } ?? []

                if status == .pending {
                    throw BankCardError.transactionStatusPending
                } else if status == .error {
                    throw BankCardError.transactionStatusError
                } else if errors.contains("RENEWAL_FAILED") {
                    throw BankCardReorderError.transactionRenewalFailed
                } else if errors.contains("DB_FAILURE") && errors.contains("SET_PIN_FAILED") {
                    throw BankCardReorderError.transactionDBFailureAndSetPinFailed
                } else if errors.contains("TM_LINK_FAILED") && errors.contains("SET_PIN_FAILED") {
                    throw BankCardReorderError.transactionTMLinkFailedAndSetPinFailed
                } else if errors.contains("SET_PIN_FAILED") {
                    throw BankCardReorderError.transactionSetPinFailed
                } else if errors.contains("DB_FAILURE") {
                    throw BankCardReorderError.transactionDBFailure
                } else if errors.contains("TM_LINK_FAILED") {
                    throw BankCardReorderError.transactionTMLinkFailed
                } else if errors.contains("GET_PAN_FAILED") {
                    throw BankCardReorderError.transactionGetPanFailed
                }

                return true
            }
            .retry(times: 20, delay: 1, when: { error in
                if case BankCardError.transactionStatusPending = error {
                    return true
                }
                return false
            })
            .eraseToAnyPublisher()
    }

    func requestBankCardInfo(cardToken: String) -> AnyPublisher<Never, AnyActionError> {

        let sessionKey = cipher.randomSessionKey()

        return Just(cardToken)
            .tryMap { cardToken -> CardDetailsQuery in
                let encryptedSessionKeyBase64 = try cipher.encryptSessionKeyRSA(sessionKey)
                return CardDetailsQuery(encryptedKey: encryptedSessionKeyBase64, cardToken: cardToken)
            }
            .flatMap { query in
                self.api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            }
            .tryMap { [responseMapperCardInfo] response -> BankCardInfo in
                try responseMapperCardInfo.map((response.cardDetails, sessionKey))
            }
            .map { [bankCardInfoStore] bankCardInfo in
                bankCardInfoStore.modify {
                    $0 = bankCardInfo
                }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func requestBankCardPin(cardToken: String) -> AnyPublisher<Never, AnyActionError> {
        let sessionKey = cipher.randomSessionKey()

        return Just(cardToken)
            .tryMap { cardToken -> CardPinQuery in
                let encryptedSessionKeyBase64 = try cipher.encryptSessionKeyRSA(sessionKey)
                return CardPinQuery(encryptedKey: encryptedSessionKeyBase64, cardToken: cardToken)
            }
            .flatMap { query in
                self.api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            }
            .tryMap { [responseMapperCardPin] response in
                try responseMapperCardPin.map((response, sessionKey))
            }
            .map { [bankCardPinStore] pin in
                bankCardPinStore.modify { $0 = pin }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }
}
