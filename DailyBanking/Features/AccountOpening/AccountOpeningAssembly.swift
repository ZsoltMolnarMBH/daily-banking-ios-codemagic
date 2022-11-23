//
//  AccountSetupAssembly.swift
//  app-daily-banking-ios
//
//  Created by Alexa Mark on 2021. 11. 15..
//

import BankAPI
import Foundation
import Resolver
import Apollo

class AccountOpeningAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext { container in
            container.resolve(AppConfig.self).accountOpening
        }
        .implements(AccountOpeningConfig.self)

        container.registerInContext {
            AccountOpeningStartPageScreenViewModel()
        }

        container.registerInContext {
            ConsentsStartPageScreenViewModel()
        }

        container.registerInContext {
            ConsentsPepScreenViewModel()
        }

        container.registerInContext {
            ConsentsDocumentScreenViewModel()
        }

        container.registerInContext {
            ConsentsTaxationScreenViewModel()
        }

        container.registerInContext {
            ConsentsDMStatementScreenViewModel()
        }

        container.registerInContext {
            AccountOpeningConditionsScreenViewModel()
        }

        container.registerInContext {
            KycSurveyTransferScreenViewModel()
        }

        container.registerInContext {
            KycSurveyDepositScreenViewModel()
        }

        container.registerInContext {
            KycSurveyIncomeScreenViewModel()
        }

        container.registerInContext {
            EmailVerificationScreenViewModel()
        }

        container.registerInContext {
            EmailAlterationScreenViewModel()
        }

        container.registerInContext(EmailAlterationScreen<EmailAlterationScreenViewModel>.self) { container in
            EmailAlterationScreen(viewModel: container.resolve())
        }

        container.registerInContext(EmailVerificationScreen<EmailVerificationScreenViewModel>.self) { container in
            EmailVerificationScreen(viewModel: container.resolve())
        }

        container.registerInContext(AccountOpeningStartPageScreen<AccountOpeningStartPageScreenViewModel>.self) { container in
            AccountOpeningStartPageScreen(viewModel: container.resolve())
        }

        container.registerInContext(ConsentsStartPageScreen<ConsentsStartPageScreenViewModel>.self) { container in
            ConsentsStartPageScreen(viewModel: container.resolve())
        }

        container.registerInContext(ConsentsPepScreen<ConsentsPepScreenViewModel>.self) { container in
            ConsentsPepScreen(viewModel: container.resolve())
        }

        container.registerInContext(ConsentsDocumentScreen<ConsentsDocumentScreenViewModel>.self) { container in
            ConsentsDocumentScreen(viewModel: container.resolve())
        }

        container.registerInContext(ConsentsTaxationScreen<ConsentsTaxationScreenViewModel>.self) { container in
            ConsentsTaxationScreen(viewModel: container.resolve())
        }

        container.registerInContext(ConsentsDMStatementScreen<ConsentsDMStatementScreenViewModel>.self) { container in
            ConsentsDMStatementScreen(viewModel: container.resolve())
        }

        container.registerInContext(AccountOpeningConditionsScreen<AccountOpeningConditionsScreenViewModel>.self) { container in
            AccountOpeningConditionsScreen(viewModel: container.resolve())
        }

        container.registerInContext(KycSurveyTransferScreen<KycSurveyTransferScreenViewModel>.self) { container in
            KycSurveyTransferScreen(viewModel: container.resolve())
        }

        container.registerInContext(KycSurveyDepositScreen<KycSurveyDepositScreenViewModel>.self) { container in
            KycSurveyDepositScreen(viewModel: container.resolve())
        }

        container.registerInContext(KycSurveyIncomeScreen<KycSurveyIncomeScreenViewModel>.self) { container in
            KycSurveyIncomeScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            let state = container.resolve(ReadOnly<Individual?>.self)
            return MemoryAccountOpeningDraftStore(state: .init(
                nextStep: .accountPackageSelection,
                selectedProduct: nil,
                individual: state.value,
                statements: nil)
            )
        }
        .implements((any AccountOpeningDraftStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<AccountOpeningDraft>.self) {
            let store: any AccountOpeningDraftStore = container.resolve()
            return store.state
        }

        container.registerInContext {
            ApplicationActionImpl()
        }.implements(ApplicationAction.self)

        container.registerInContext {
            ContractScreenViewModel()
        }

        container.registerInContext(DocumentViewerScreen<ContractScreenViewModel>.self) { container in
            DocumentViewerScreen(viewModel: container.resolve())
        }

        container.registerInContext(Mapper<GetApplicationQuery.Data, AccountOpeningDraft>.self) {
            ApplicationMapper()
        }
    }
}
