//
//  AccountClosingWithdrawalScreenViewModel.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 26..
//

import Foundation
import Resolver
import Combine

enum AccountClosingSignScreenResult {
    case accountClosingStatementRequested(contractId: String)
}

class AccountClosingSignScreenViewModel: ScreenViewModel<AccountClosingSignScreenResult>,
                                         AccountClosingSignScreenViewModelProtocol {

    @Injected var accountClosingAction: AccountClosingAction
    @Injected var account: ReadOnly<Account?>
    @Injected var draft: ReadOnly<AccountClosingDraft>
    @Injected var displayStrings: AccountClosingDisplayStringFactory

    @Published var isStatementGenerating: Bool = false
    @Published var errorDisplay: ResultModel?
    var title: String {
        displayStrings.signingScreenTitle
    }
    var text1: String {
        displayStrings.signingScreenText1
    }
    var text2: String {
        displayStrings.signingScreenText2
    }

    var onGoBack: (() -> Void)?

    private var disposeBag: Set<AnyCancellable> = .init()

    func handle(event: AccountClosingSignScreenInput) {
        switch event {
        case .sign:
            generateClosingStatement()
        case .goBack:
            onGoBack?()
        }
    }

    private func generateClosingStatement() {
        guard let accountId = account.value?.accountId else { return }

        isStatementGenerating = true
        accountClosingAction.createAccountClosureStatement(
            accountId: accountId, pollingInterval: 2.0
        ).receive(on: DispatchQueue.main).sink { [weak self] result in
            switch result {
            case .finished:
                self?.isStatementGenerating = false
                guard let withdrawalStatementContractId = self?.draft.value.withdrawalStatementContractId else { return }
                self?.events.send(.accountClosingStatementRequested(contractId: withdrawalStatementContractId))
            case .failure:
                self?.errorDisplay = .genericError(screenName: "AccountClosingSignScreen", action: {
                    self?.errorDisplay = nil
                })
            }
        }.store(in: &disposeBag)
    }
}
