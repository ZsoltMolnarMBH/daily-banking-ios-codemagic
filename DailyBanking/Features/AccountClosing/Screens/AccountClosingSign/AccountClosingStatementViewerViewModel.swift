//
//  AccountClosingStatementViewerViewModel.swift
//  DailyBanking
//
//  Created by ALi on 2022. 06. 10..
//

import Foundation
import Resolver
import Combine

enum AccountClosingStatementViewerScreenResult {
    case accountClosingFlowDone
}

class AccountClosingStatementViewerViewModel: ScreenViewModel<AccountClosingStatementViewerScreenResult>,
                                              DocumentViewerScreenViewModelProtocol {

    @Injected var accountClosingAction: AccountClosingAction
    @Injected var account: ReadOnly<Account?>
    @Injected var draft: ReadOnly<AccountClosingDraft>

    @Published var error: ResultModel?
    @Published var isLoading: Bool = false
    @Published var finished: Bool = false

    var actionTitle: String? = Strings.Localizable.accountClosingWithdrawalStatementPreviewSign
    var showShareButton: Bool = true
    let source: DocumentSource?

    private var disposeBag: Set<AnyCancellable> = .init()

    init(closingDocument: DocumentSource) {
        self.source = closingDocument
    }

    func handle(event: DocumentViweerScreenInput) {
        switch event {
        case .onAppear:
            break
        case .actionButtonPressed:
            closeAccount()
        }
    }

    private func closeAccount() {
        guard let accountId = account.value?.accountId else {
            return
        }

        self.isLoading = true

        accountClosingAction
            .closeAccount(accountId: accountId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.isLoading = false
                switch result {
                case .finished:
                    self?.events.send(.accountClosingFlowDone)
                case .failure:
                    self?.error = .genericError(screenName: "AccountClosingStatementViewer", action: {
                        self?.error = nil
                    })
                }
            }.store(in: &disposeBag)
    }
}
