//
//  BankCardBlockViewModel.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 17..
//

import Foundation
import Resolver
import DesignKit
import SwiftUI
import Combine

protocol BankCardBlockViewModelProtocol: ObservableObject {

    var isLoading: Bool { get set }

    var bottomAlert: AnyPublisher<AlertModel, Never> { get }

    func handle(_ event: BankCardBlockScreenInput)
}

enum BankCardBlockScreenInput {
    case block
    case cancel
}

protocol BankCardBlockScreenListener: AnyObject {

    func resultRequested()
    func blockCancelled()
    func reorderCardRequested(cardToken: String)
}

class BankCardBlockViewModel: BankCardBlockViewModelProtocol {

    var bottomAlertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        bottomAlertSubject.eraseToAnyPublisher()
    }
    weak var screenListener: BankCardBlockScreenListener?
    var onClose: (() -> Void)?
    private var disposeBag = Set<AnyCancellable>()
    var cardToken: String?
    @Injected var bankCardAction: BankCardAction

    @Published var isLoading: Bool = false

    func handle(_ event: BankCardBlockScreenInput) {

        switch event {
        case .block:
            blockCard()
        case .cancel:
            onClose?()
        }
    }

    private func blockCard() {

        isLoading = true

        bankCardAction.setCardState(state: .blocked, cardToken: cardToken ?? "")
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    self?.screenListener?.resultRequested()
                case .failure:
                    self?.bottomAlertSubject.send(.init(
                        title: Strings.Localizable.bankCardBlockErrorScreenTitle,
                        imageName: .alertSemantic,
                        subtitle: Strings.Localizable.bankCardBlockErrorScreenSubtitle,
                        actions: [
                            .init(title: Strings.Localizable.commonCancel,
                                  kind: .secondary,
                                  handler: { self?.screenListener?.blockCancelled() }),
                            .init(title: Strings.Localizable.commonRetry,
                                  handler: { self?.blockCard() })
                        ]
                   ))
                }
            }
            .store(in: &disposeBag)
    }
}
