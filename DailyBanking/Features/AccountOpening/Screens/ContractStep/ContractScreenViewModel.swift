//
//  ContractScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 20..
//

import Foundation
import Combine
import Resolver
import DesignKit
import PDFKit

protocol ContractScreenListener: AnyObject {
    func onContractAccepted()
}

class ContractScreenViewModel: DocumentViewerScreenViewModelProtocol {
    @Published var source: DocumentSource?
    @Published var isLoading: Bool = false
    @Published var error: ResultModel?

    var finished: Bool = false
    var actionTitle: String? = Strings.Localizable.contractSigningSigning
    var showShareButton = true

    weak var screenListener: ContractScreenListener?

    @Injected var draft: ReadOnly<AccountOpeningDraft>
    @Injected var applicationAction: ApplicationAction
    @Injected var accountAction: AccountAction

    private var disposeBag = Set<AnyCancellable>()

    private func viewDidAppear() {
        draft.publisher
            .compactMap { $0.contractID }
            .first()
            .removeDuplicates()
            .map { DocumentSource.contract($0) }
            .assign(to: &$source)
    }

    func handle(event: DocumentViweerScreenInput) {
        switch event {
        case .onAppear:
            viewDidAppear()
        case .actionButtonPressed:
            signContract()
        }
    }

    private func signContract() {
        isLoading = true
        applicationAction
            .signContract()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.requestAccount()
                case .failure:
                    self?.isLoading = false
                    self?.showError(then: { [weak self] in
                        self?.signContract()
                    })
                }
            }
            .store(in: &disposeBag)
    }

    private func requestAccount() {
        isLoading = true
        applicationAction
            .requestAccount()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.refreshAccount()
                case .failure(let actionError):
                    self?.isLoading = false
                    if case .action(let applicationActionError) = actionError,
                       applicationActionError == .accountCreationBlocked {
                        self?.error = .accountCreationFailed()
                    } else {
                        self?.showError(then: { [weak self] in
                            self?.requestAccount()
                        })
                    }
                }
            })
            .store(in: &disposeBag)
    }

    private func refreshAccount() {
        isLoading = true
        accountAction.refreshAccounts()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.screenListener?.onContractAccepted()
                case .failure:
                    self?.isLoading = false
                    self?.showError(then: { [weak self] in
                        self?.refreshAccount()
                    })
                }
            })
            .store(in: &disposeBag)
    }

    private func showError(then handler: @escaping () -> Void) {
        error = .genericError(screenName: "oao_present_contract_error_try_again", action: { [weak self] in
            self?.error = nil
            handler()
        })
    }
}
