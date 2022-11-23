//
//  NewTransferAssembly.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 25..
//

import Resolver
import BankAPI

extension Resolver.Name {
    static let newTransfer = NewTransfer()
    struct NewTransfer { }
}

extension Resolver.Name.NewTransfer {
    var fee: Resolver.Name { ".newTransfer.fee" }
    var limit: Resolver.Name { ".newTransfer.limit" }
}

class NewTransferAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext { container in
            container.resolve(AppConfig.self).newTransfer
        }
        .implements(NewTransferConfig.self)

        container.registerInContext {
            NewTransferActionImpl()
        }
        .implements(NewTransferAction.self)
        .scope(container.cache)

        container.registerInContext {
            MemoryNewTransferDraftStore()
        }
        .implements((any NewTransferDraftStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<NewTransferDraft>.self) { container in
            let store: (any NewTransferDraftStore) = container.resolve()
            return store.state
        }

        container.registerInContext(name: .newTransfer.fee) {
            MemoryMoneyProcessStore(state: nil) as (any MoneyProcessStore)
        }
        .scope(container.cache)

        container.registerInContext(ReadOnly<MoneyProcess?>.self, name: .newTransfer.fee) { container in
            container.resolve((any MoneyProcessStore).self, name: .newTransfer.fee).state
        }

        container.registerInContext(name: .newTransfer.limit) {
            MemoryMoneyProcessStore(state: nil) as (any MoneyProcessStore)
        }
        .scope(container.cache)

        container.registerInContext(ReadOnly<MoneyProcess?>.self, name: .newTransfer.limit) { container in
            container.resolve((any MoneyProcessStore).self, name: .newTransfer.limit).state
        }

        container.registerInContext {
            BeneficiaryScreenViewModel()
        }

        container.registerInContext { container in
            BeneficiaryScreen<BeneficiaryScreenViewModel>(viewModel: container.resolve())
        }

        container.registerInContext {
            AmountScreenViewModel()
        }

        container.registerInContext { container in
            AmountScreen<AmountScreenViewModel>(viewModel: container.resolve())
        }

        container.registerInContext {
            NewTransferSummaryScreenViewModel()
        }

        container.registerInContext { container in
            NewTransferSummaryScreen<NewTransferSummaryScreenViewModel>(viewModel: container.resolve())
        }

        container.registerInContext { _, args -> NewTransferSuccessScreenViewModel in
            let transaction: PaymentTransaction = args.get()
            return NewTransferSuccessScreenViewModel(transaction: transaction)
        }

        container.registerInContext { container, args in
            NewTransferSuccessScreen<NewTransferSuccessScreenViewModel>(viewModel: container.resolve(args: args))
        }
    }
}
