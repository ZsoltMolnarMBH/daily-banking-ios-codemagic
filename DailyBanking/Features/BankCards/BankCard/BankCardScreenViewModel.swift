//
//  CardScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 21..
//

import Foundation
import Resolver
import DesignKit
import SwiftUI
import Combine

protocol BankCardScreenListener: AnyObject {
    func helpRequested()
    func cardInfoRequested()
    func pinCodeRevealRequested()
    func cardLimitRequested()
    func blockCardRequested(cardToken: String)
    func reorderCardRequested(cardToken: String)
}

class BankCardScreenViewModel: BankCardScreenViewModelProtocol {
    weak var screenListener: BankCardScreenListener?
    var onFinished: (() -> Void)?
    private var disposeBag = Set<AnyCancellable>()
    @Injected var bankCardStore: ReadOnly<BankCard?>
    @Injected var bankCardAction: BankCardAction

    @Published var cardName: String = ""
    @Published var cardNumberLastDigits: String = ""
    @Published var cardState: BankCard.State = .active
    @Published var isLoading: Bool = true
    @Published var isLoadingFullScreen: Bool = false
    @Published var infoBoxParams: BankCardInfoBoxParams?
    @Published var statusViewParams: BankCardStatusViewParams?
    @Published var freezeButtonLabel: String = ""
    @Published var freezeButtonStyle: VerticalButton.Style = .secondary

    init() {
        bankCardStore.publisher
            .compactMap { $0 }
            .sink { [weak self] bankCard in
                self?.populate(bankCard: bankCard)
            }
            .store(in: &disposeBag)

        $cardState.sink { [weak self] cardState in
            self?.setupInfobox(cardState)
            self?.setupStatusView(cardState)
            self?.freezeButtonLabel = (cardState == .frozen ?
                                       Strings.Localizable.bankCardDetailsUnfreezeCard : Strings.Localizable.bankCardDetailsFreezeCard)
            self?.freezeButtonStyle = (cardState == .frozen ? .primary : .secondary)
        }
        .store(in: &disposeBag)
    }

    deinit {
        onFinished?()
    }

    private func populate(bankCard: BankCard) {
        cardName = Strings.Localizable.bankCardMastercardName
        cardNumberLastDigits = bankCard.numberLastDigits
        cardState = bankCard.state
    }

    private func setupInfobox(_ cardState: BankCard.State) {
        switch cardState {
        case .frozen:
             infoBoxParams = .init(
                status: .info,
                title: Strings.Localizable.bankCardDetailsStateFrozenIntoTitle,
                subtitle: Strings.Localizable.bankCardDetailsStateFrozenIntoDescription)
        default:
            infoBoxParams = nil
        }
    }

    private func setupStatusView(_ cardState: BankCard.State) {
        switch cardState {
        case .blocked:
            statusViewParams = nil
        case .transactionDBFailure:
            statusViewParams = .init(
                image: Image(.warningSemantic),
                title: Strings.Localizable.bankCardDetailsNoCardDataTitle,
                subtitle: Strings.Localizable.bankCardDetailsNoCardDataDescription)
        case .transactionTMLinkFailed:
            statusViewParams = .init(
                image: Image(.stopwatchNeutral),
                title: Strings.Localizable.bankCardDetailsReorderInProgressTitle,
                subtitle: Strings.Localizable.bankCardDetailsReorderInProgressDescription)
        default:
            statusViewParams = nil
        }
    }

    func handle(_ event: BankCardScreenInput) {
        switch event {
        case .help:
            screenListener?.helpRequested()
        case .cardInfo:
            showCardInfoScreen()
        case .showPin:
            showPinCodeRevealScreen()
        case .freezeCard:
            freezeCard()
        case .cardLimit:
            screenListener?.cardLimitRequested()
        case .blockCard:
            screenListener?.blockCardRequested(cardToken: bankCardStore.value?.cardToken ?? "")
        case .orderCard:
            screenListener?.reorderCardRequested(cardToken: bankCardStore.value?.cardToken ?? "")
        case .onAppear:
            loadData()
        }
    }

    private func loadData() {

        isLoading = bankCardStore.value == nil

        bankCardAction.requestBankCard()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure:
                    break
                }
            }
            .store(in: &disposeBag)
    }

    private func freezeCard() {

        isLoadingFullScreen = true
        let state: BankCard.State = bankCardStore.value?.state == .frozen ? .active : .frozen
        bankCardAction.setCardState(state: state, cardToken: bankCardStore.value?.cardToken ?? "")
            .sink { [weak self] completion in
                self?.isLoadingFullScreen = false
                switch completion {
                case .finished:
                    state == .frozen ? self?.bankCardFrozen() : self?.bankCardFreezingUnlocked()
                case .failure:
                    break
                }
            }
            .store(in: &disposeBag)
    }

    private func showCardInfoScreen() {
        bankCardAction.requestBankCardInfo(cardToken: bankCardStore.value?.cardToken ?? "")
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.screenListener?.cardInfoRequested()
                case .failure:
                    break
                }
            }
            .store(in: &disposeBag)
    }

    private func showPinCodeRevealScreen() {
        bankCardAction.requestBankCardPin(cardToken: bankCardStore.value?.cardToken ?? "")
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.screenListener?.pinCodeRevealRequested()
                case .failure:
                    break
                }
            }
            .store(in: &disposeBag)
    }

    func bankCardFrozen() {
        Modals.toast.show(text: Strings.Localizable.cardTransactionDeclineCardFrozen)
    }

    func bankCardFreezingUnlocked() {
        Modals.toast.show(text: Strings.Localizable.bankCardFreezingUnlocked)
    }
}

struct BankCardInfoBoxParams {
    let status: InfoBox.Status
    let title: String
    let subtitle: String
}

struct BankCardStatusViewParams {
    let image: Image
    let title: String
    let subtitle: String
}
