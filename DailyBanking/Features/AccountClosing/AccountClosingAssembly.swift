//
//  AccountClosingAssembly.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 18..
//

import Foundation
import Resolver
import BankAPI

class AccountClosingAssembly: Assembly {

    func assemble(container: Resolver) {
        container.registerInContext {
            AccountClosingReasonScreenViewModel()
        }

        container.registerInContext(AccountClosingReasonScreen<AccountClosingReasonScreenViewModel>.self) {
            AccountClosingReasonScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            AccountClosingDocumentsScreenViewModel()
        }

        container.registerInContext(AccountClosingDocumentsScreen<AccountClosingDocumentsScreenViewModel>.self) {
            AccountClosingDocumentsScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            AccountClosingTransferScreenViewModel()
        }

        container.registerInContext(AccountClosingTransferScreen<AccountClosingTransferScreenViewModel>.self) {
            AccountClosingTransferScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            AccountClosingSignScreenViewModel()
        }

        container.registerInContext(AccountClosingSignScreen<AccountClosingSignScreenViewModel>.self) {
            AccountClosingSignScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            MemoryAccountClosingDraftStore(draft: .init())
        }
        .implements((any AccountClosingDraftStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<AccountClosingDraft>.self) {
            let store: any AccountClosingDraftStore = container.resolve()
            return store.state
        }

        container.registerInContext {
            AccountClosingActionImpl()
        }
        .implements(AccountClosingAction.self)

        container.registerInContext {
            AccountClosingDisplayStringFactory()
        }
    }
}
