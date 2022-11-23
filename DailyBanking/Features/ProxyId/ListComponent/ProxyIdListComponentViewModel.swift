//
//  ProxyIdListComponentViewModel.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 11..
//

import Resolver
import Combine
import DesignKit

enum ProxyIdListComponentResult {
    case proxyIdCreationRequested
}

class ProxyIdListComponentViewModel: ScreenViewModel<ProxyIdListComponentResult>,
                                     ProxyIdListComponentViewModelProtocol {

    @Injected private var account: ReadOnly<Account?>
    @Injected private var accountAction: AccountAction

    @Published var items: [ProxyId] = []
    private let _actionSheet = PassthroughSubject<ActionSheetModel, Never>()
    var actionSheet: AnyPublisher<ActionSheetModel, Never> {
        _actionSheet.eraseToAnyPublisher()
    }
    private var alertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        alertSubject.eraseToAnyPublisher()
    }

    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        account.publisher
            .map { $0?.proxyIds ?? [] }
            .sink { [weak self] items in
                self?.items = items
            }
            .store(in: &disposeBag)
    }

    func handle(event: ProxyIdListComponentEvent) {
        switch event {
        case .add:
            events.send(.proxyIdCreationRequested)
        case .delete(let proxyId):
            showDeleteConfirmation(for: proxyId)
        }
    }

    private func showDeleteConfirmation(for proxyId: ProxyId) {
        guard proxyId.kind == .emailAddress || proxyId.kind == .phoneNumber else { return }
        let email = Strings.Localizable.secondaryIdDeleteConfirmationOptionEmail
        let mobile = Strings.Localizable.secondaryIdDeleteConfirmationOptionMobile
        let title = proxyId.kind == .emailAddress ? email : mobile
        _actionSheet.send(.init(
            title: Strings.Localizable.secondaryIdDeleteConfirmationDialogTitle,
            items: [
                .init(title: title, iconName: DesignKit.ImageName.delete.rawValue, action: { [weak self] in
                    self?.deleteConfirmed(for: proxyId)
                })
            ])
        )
    }

    private func deleteConfirmed(for proxyId: ProxyId) {
        guard let account = account.value else { return }
        accountAction.deleteProxyId(from: account, alias: proxyId.value)
            .sink(receiveCompletion: { [weak self, accountAction] completion in
                switch completion {
                case .finished:
                    accountAction.refreshAccounts().fireAndForget()
                case .failure:
                    self?.alertSubject.send(.genericError(
                        onRetry: { [weak self] in self?.deleteConfirmed(for: proxyId) })
                    )
                }
            })
            .store(in: &disposeBag)
    }
}
