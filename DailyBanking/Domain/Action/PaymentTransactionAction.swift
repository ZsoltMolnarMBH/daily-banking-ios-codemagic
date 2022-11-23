//
//  PaymentTransactionAction.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 31..
//

import Combine
import BankAPI
import Foundation
import Resolver

protocol PaymentTransactionAction {
    func refreshPaymentTransactions(of account: Account) -> AnyPublisher<Never, AnyActionError>
}

class PaymentTransactionActionImpl: PaymentTransactionAction {
    @Injected private var api: APIProtocol
    @Injected private var paymentTransactionMapper: Mapper<PaymentTransactionFragment, PaymentTransaction>
    @Injected private var paymentTransactionStore: any PaymentTransactionStore

    private var refreshingTransactions: AnyPublisher<Never, AnyActionError>?

    func refreshPaymentTransactions(of account: Account) -> AnyPublisher<Never, AnyActionError> {
        if let refreshingTransactions = refreshingTransactions {
            return refreshingTransactions
        }

        let refresh = api.publisher(
            for: ListPaymentTransactionsQuery(accountId: account.accountId),
               cachePolicy: .fetchIgnoringCacheCompletely)
            .print()
            .map { [paymentTransactionMapper] data in
                let dto = data.listPaymentTransactions.compactMap { $0.fragments.paymentTransactionFragment }
                return paymentTransactionMapper.compactMap(dto)
            }
            .print()
            .map { [paymentTransactionStore] payments in
                paymentTransactionStore.modify {
                    $0 = payments
                }
            }
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.refreshingTransactions = nil
            }, receiveCancel: { [weak self] in
                self?.refreshingTransactions = nil
            })
            .ignoreOutput()
            .share()
            .eraseToAnyPublisher()
            .mapAnyActionError()

        refreshingTransactions = refresh
        return refresh
    }
}
