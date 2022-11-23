//
//  ProxyIdConfirmationScreenViewModel.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 13..
//

import Resolver
import Combine

enum ProxyIdConfirmationScreenResult {
    case privacyPolicyRequested
    case proxyIdCreated
}

class ProxyIdConfirmationScreenViewModel: ScreenViewModel<ProxyIdConfirmationScreenResult>,
                                          ProxyIdConfirmationScreenViewModelProtocol {

    @Injected private var draft: ReadOnly<ProxyIdDraft>
    @Injected private var action: AccountAction
    @Injected private var account: ReadOnly<Account?>
    private var disposeBag = Set<AnyCancellable>()

    var kind: String = ""
    var value: String = ""
    var hint: String = Strings.Localizable.accountDetailsSecondaryIdAddDescription

    @Published var isPrivacyNoticeAccepted: Bool = false
    var isConfirmationAvailable: Bool {
        isPrivacyNoticeAccepted
    }
    @Published var isLoading: Bool = false

    private var alertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        alertSubject.eraseToAnyPublisher()
    }

    override init() {
        super.init()
        guard let kind = draft.value.kind, let value = draft.value.value else {
            fatalError()
        }
        self.kind = kind.localized
        self.value = ProxyId.formatted(value: value, using: kind)
    }

    func handle(event: ProxyIdConfirmationScreenInput) {
        switch event {
        case .privacyPolicy:
            events.send(.privacyPolicyRequested)
        case .confirm:
            confirmCreation()
        }
    }

    private func confirmCreation() {
        guard let value = draft.value.value else {
            fatalError()
        }
        guard let account = account.value else {
            fatalError()
        }
        isLoading = true
        action.addProxyId(to: account, alias: value)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    self.events.send(.proxyIdCreated)
                case .failure:
                    self.alertSubject.send(.genericError(onRetry: { [weak self] in self?.confirmCreation() }))
                }
            }
            .store(in: &disposeBag)
    }
}
