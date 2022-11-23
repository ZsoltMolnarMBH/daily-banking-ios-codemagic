//
//  NewTransferAction.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 02. 23..
//

import Resolver
import Combine
import BankAPI
import Foundation
import Apollo

protocol NewTransferAction {
    func updateDailyLimit() -> AnyPublisher<Never, AnyActionError>
    func transactionFee(for money: Money) -> AnyPublisher<Never, AnyActionError>
    func initiateNewTransfer() -> AnyPublisher<NewTransferSuccess, ActionError<NewTransferError>>
}

class NewTransferActionImpl: NewTransferAction {
    @Injected private var config: NewTransferConfig
    @Injected private var api: APIProtocol
    @Injected private var account: ReadOnly<Account?>
    @Injected private var draft: ReadOnly<NewTransferDraft>
    @Injected private var draftStore: any NewTransferDraftStore
    @Injected(name: .newTransfer.fee) private var feeStore: any MoneyProcessStore
    @Injected(name: .newTransfer.limit) private var limitStore: any MoneyProcessStore
    @Injected private var transactionMapper: Mapper<PaymentTransactionFragment, PaymentTransaction>
    @Injected private var rejectionMapper: Mapper<RejectionReason, TransferRejection>
    @Injected private var moneyMapper: Mapper<MoneyFragment, Money>

    func updateDailyLimit() -> AnyPublisher<Never, AnyActionError> {
        let dispatchQueue = DispatchQueue(label: UUID().uuidString)
        return Just(account.value!.iban)
            .receive(on: dispatchQueue)
            .map { iban in
                GetDailyLimitRemainingQuery(iban: iban)
            }
            .handleEvents(receiveOutput: { [limitStore] _ in
                limitStore.modify {
                    $0 = .loading
                }
            })
            .flatMap { [api] query in
                api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            }
            .tryMap { [moneyMapper, limitStore] response in
                let money = response.getDailyLimitRemaining.fragments.moneyFragment
                let limit = try moneyMapper.map(money)
                limitStore.modify {
                    $0 = .success(limit)
                }
            }
            .tryCatch { [limitStore] error -> AnyPublisher<Void, Error> in
                limitStore.modify {
                    $0 = .failure(error)
                }
                throw error
            }
            .ignoreOutput()
            .receive(on: DispatchQueue.main)
            .mapAnyActionError()
    }

    func transactionFee(for money: Money) -> AnyPublisher<Never, AnyActionError> {
        let dispatchQueue = DispatchQueue(label: UUID().uuidString)
        guard money.value > 0 else {
            return Just(Money(value: 0, currency: money.currency))
                .map { [feeStore] fee in
                    feeStore.modify {
                        $0 = .success(fee)
                    }
                }
                .ignoreOutput()
                .receive(on: DispatchQueue.main)
                .mapAnyActionError()
        }
        return Just(money)
            .receive(on: dispatchQueue)
            .map { money in
                GetTransactionFeeQuery(input: .init(
                    amount: money.value.doubleValue,
                    currencyCode: .init(rawValue: money.currency) ?? .huf))
            }
            .handleEvents(receiveOutput: { [feeStore] _ in
                feeStore.modify {
                    $0 = .loading
                }
            })
            .map { [api] query in
                api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            }
            .switchToLatest()
            .tryMap { [moneyMapper, feeStore] result in
                let feeDTO = result.getTransactionFee.fragments.moneyFragment
                let fee = try moneyMapper.map(feeDTO)
                feeStore.modify {
                    $0 = .success(fee)
                }
            }
            .tryCatch { [feeStore] error -> AnyPublisher<Void, Error> in
                feeStore.modify {
                    $0 = .failure(error)
                }
                throw error
            }
            .ignoreOutput()
            .receive(on: DispatchQueue.main)
            .mapAnyActionError()
    }

    func initiateNewTransfer() -> AnyPublisher<NewTransferSuccess, ActionError<NewTransferError>> {
        guard let account = account.value,
              let beneficiary = draft.value.beneficiary,
              let money = draft.value.money else {
            fatalError()
        }

        let dispatchQueue = DispatchQueue(label: UUID().uuidString)

        enum TransactionPollingError: Error {
            case communicationError(CommunicationError)
            case stillPending(PaymentTransaction)
        }

        return Just((draft.value, account))
            .receive(on: dispatchQueue)
            .map { draft, account in
                return InitiateNewTransferV2Mutation(input: .init(
                    debtor: .init(
                        identification: account.iban,
                        identificationType: .iban),
                    creditor: .init(
                        name: beneficiary.name,
                        account: .init(
                            identificationType: .bban,
                            identification: beneficiary.accountNumber)),
                    creditInstruction: .init(
                        money: .init(
                            amount: money.value.doubleValue,
                            currencyCode: .init(rawValue: money.currency) ?? .huf),
                        remittanceInformation: .init(
                            reference: draft.notice))
                ))
            }
            .flatMap { [api] mutation -> AnyPublisher<InitiateNewTransferV2Mutation.Data, Swift.Error> in
                api.publisher(for: mutation)
            }
            .map { response in
                response.initiateNewTransferV2.id
            }
            .flatMap { [api, transactionMapper, config] id -> AnyPublisher<PaymentTransaction, Error> in
                let query = GetPaymentTransactionsQuery(transactionId: id)
                return Just(query)
                    .flatMap {
                        api.publisher(for: $0, cachePolicy: .fetchIgnoringCacheCompletely)
                    }
                    .tryMap { response in
                        let paymentTransactionFragment = response.getPaymentTransaction.fragments.paymentTransactionFragment
                        let transaction = try transactionMapper.map(paymentTransactionFragment!)
                        if transaction.state == .pending {
                            throw TransactionPollingError.stillPending(transaction)
                        }
                        return transaction
                    }
                    .retry(times: config.pollCount - 1,
                           delay: config.pollingInterval,
                           when: { error in
                        if let pollingError = error as? TransactionPollingError {
                            if case .stillPending = pollingError {
                                return true
                            }
                        }
                        return false
                    })
                    .tryCatch { error -> AnyPublisher<PaymentTransaction, Error> in
                        if let pollingError = error as? TransactionPollingError {
                            if case .stillPending(let transaction) = pollingError {
                                return Just(transaction)
                                    .setFailureType(to: Error.self)
                                    .eraseToAnyPublisher()
                            }
                        }
                        if let communicationError = error as? CommunicationError {
                            throw TransactionPollingError.communicationError(communicationError)
                        }
                        throw error
                    }
                    .eraseToAnyPublisher()
            }
            .tryMap { transaction -> NewTransferSuccess in
                switch transaction.state {
                case .completed, .pending:
                    return NewTransferSuccess(transaction: transaction)
                case .rejected:
                    let rejectReason = transaction.rejectionReason ?? .unknown("")
                    throw NewTransferError.rejected(rejectReason)
                }
            }
            .tryCatch { [rejectionMapper] error -> AnyPublisher<NewTransferSuccess, Error> in
                if let newTransferError = error as? NewTransferError {
                    throw newTransferError
                }
                if let pollingError = error as? TransactionPollingError {
                    if case .communicationError = pollingError {
                        return Just(NewTransferSuccess(transaction: nil))
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    }
                }
                if error is GraphQLResultError {
                    return Just(NewTransferSuccess(transaction: nil))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                if let badResponse = error.graphQLError(statusCode: 400) {
                    if let internalErrorCode = badResponse.status,
                       let rejectionReason = RejectionReason(rawValue: internalErrorCode),
                       let rejection = try? rejectionMapper.map(rejectionReason) {
                        throw NewTransferError.rejected(rejection)
                    }
                }
                throw error
            }
            .receive(on: DispatchQueue.main)
            .mapActionError(to: NewTransferError.self)
    }
}
