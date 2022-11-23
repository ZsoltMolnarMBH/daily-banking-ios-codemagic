//
//  MainAssembly.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 16..
//

import BankAPI
import Foundation
import Resolver

class MainAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext { container in
            container.resolve(AppConfig.self).session
        }
        .implements(SessionConfig.self)

        container.registerInContext { container in
            container.resolve(AppConfig.self).general
        }
        .implements(PushSubscriptionConfig.self)

        container.registerInContext {
            ScaChallengeActionImpl()
        }
        .implements(ScaChallengeAction.self)
        .scope(container.cache)

        container.registerInContext {
            PaymentTransactionActionImpl()
        }
        .implements(PaymentTransactionAction.self)
        .scope(container.cache)

        container.registerInContext {
            PinVerification()
        }
        .scope(container.cache)

        container.registerInContext {
            UserActionImpl()
        }
        .implements(UserAction.self)

        container.registerInContext {
            AccountActionImpl()
        }
        .implements(AccountAction.self)
        .scope(container.cache)

        container.registerInContext {
            MemoryPaymentTransactionStore()
        }
        .implements((any PaymentTransactionStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<[PaymentTransaction]>.self) { container in
            container.resolve((any PaymentTransactionStore).self).state
        }

        container.registerInContext {
            MemoryScaChallengeStore()
        }
        .implements(ScaChallengeStore.self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<[ScaChallenge]>.self) { container in
            container.resolve(ScaChallengeStore.self).state
        }

        container.registerInContext {
            MemoryAccountStore()
        }
        .implements((any AccountStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<Account?>.self) { container in
            container.resolve((any AccountStore).self).state
        }

        container.registerInContext {
            MemoryIndividualStore()
        }
        .implements((any IndividualStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<Individual?>.self) { container in
            container.resolve((any IndividualStore).self).state
        }

        container.registerInContext(Mapper<AccountFragment, Account>.self) {
            AccountListMapper()
        }

        container.registerInContext(Mapper<IndividualFragment, Individual>.self) {
            IndividualMapper()
        }

        container.registerInContext(Mapper<Individual, User?>.self) {
            UserMapper()
        }

        container.registerInContext(Mapper<UserContractFragment, UserContract>.self) {
            ContractListMapper()
        }

        container.registerInContext(Mapper<AccountFragment.ProxyId, ProxyId>.self) {
            ProxyIdMapper()
        }

        container.registerInContext(Mapper<RejectionReason, TransferRejection>.self) {
            TransferRejectionMapper()
        }

        container.registerInContext(Mapper<PaymentTransactionFragment, PaymentTransaction>.self) {
            PaymentTransactionMapper()
        }

        container.registerInContext(Mapper<[ScaChallengeFragment], [ScaChallenge]>.self) {
            ScaChallengeListMapper()
        }

        container.registerInContext(ContactsScreen<ContactsScreenViewModel>.self) { container in
            ContactsScreen(viewModel: container.resolve())
        }

        container.registerInContext(ProxyIdListComponentViewModel.self) {
            ProxyIdListComponentViewModel()
        }

        container.registerInContext(ScaChallengeListComponentViewModel.self) {
            ScaChallengeListComponentViewModel()
        }

        container.registerInContext {
            MemoryUserContractStore()
        }
        .implements((any UserContractStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<[UserContract]>.self) { container in
            let store = container.resolve((any UserContractStore).self)
            return store.state
        }

        container.registerInContext(Mapper<StatementFragment, MonthlyStatement>.self) {
            MonthlyStatementMapper()
        }

        container.registerInContext {
            MemoryMonthlyStatementsStore()
        }
        .implements((any MonthlyStatementsStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<[MonthlyStatement]>.self) { container in
            let store = container.resolve((any MonthlyStatementsStore).self)
            return store.state
        }

        container.registerInContext {
            VerifyPinViewModel()
        }

        container.registerInContext(PinPadScreen<VerifyPinViewModel>.self) { container in
            .init(viewModel: container.resolve())
        }

        container.registerInContext {
            SecondLevelAuthViewModel()
        }

        container.registerInContext(PinPadScreen<SecondLevelAuthViewModel>.self) { container in
            .init(viewModel: container.resolve())
        }

        container.registerInContext {
            PaymentTransactionHistoryScreenViewModel()
        }

        container.registerInContext(PaymentTransactionHistoryScreen<PaymentTransactionHistoryScreenViewModel>.self) { container in
            PaymentTransactionHistoryScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            PaymentTransactionDetailsScreenViewModel()
        }

        container.registerInContext(PaymentTransactionDetailsScreen<PaymentTransactionDetailsScreenViewModel>.self) { container in
            PaymentTransactionDetailsScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            BackgroundTimeObserver()
        }

        container.registerInContext {
            ForegroundActivityObserver()
        }

        container.registerInContext {
            PushSubscriptionWorker()
        }
        .scope(container.cache)
    }
}
