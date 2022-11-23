//
//  AccountSetupAssembly.swift
//  app-daily-banking-ios
//
//  Created by Alexa Mark on 2021. 11. 15..
//

import Foundation
import Resolver
import Apollo
import UIKit

class AccountSetupAssembly: Assembly {
    func assemble(container: Resolver) {
        container.register {
            AccountSetupScreenViewModel()
        }

        container.register {
            AccountSetupContactsScreenViewModel()
        }

        container.register(AccountSetupScreen<AccountSetupScreenViewModel>.self) { container in
            AccountSetupScreen(viewModel: container.resolve())
        }

        container.register(AccountSetupContactsScreen<AccountSetupContactsScreenViewModel>.self) { container in
            AccountSetupContactsScreen(viewModel: container.resolve())
        }

        container.register {
            PersonDraftAdapter()
        }

        container.register(PersonDraftStore.self) {
            let adapter = container.resolve(PersonDraftAdapter.self)
            return PersonDraftStoreImpl(personDraft: adapter.state.value)
        }
        .scope(.container)

        container.register(ReadOnly<PersonDraft>.self) { container in
            let store = container.resolve(PersonDraftStore.self)
            return store.state
        }

        container.register {
            RequestContractActionImpl()
        }
        .implements(RequestContractAction.self)

        container.register {
            ContractScreenViewModel()
        }

        container.register(ContractScreen<ContractScreenViewModel>.self) { container in
            ContractScreen(viewModel: container.resolve())
        }
    }
}
