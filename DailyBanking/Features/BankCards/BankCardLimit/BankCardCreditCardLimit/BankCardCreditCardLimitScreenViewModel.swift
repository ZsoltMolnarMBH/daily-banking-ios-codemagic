//
//  BankCardCreditCardLimitScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 08..
//

import Foundation
import Combine
import DesignKit
import AnyFormatKit
import Resolver

protocol BankCardCreditCardLimitScreenListener: AnyObject {
    func creditCardOnlineLimitInfoRequested()
    func limitChangeCancelled()
}

class BankCardCreditCardLimitScreenViewModel: BankCardCreditCardLimitScreenViewModelProtocol {

    var bottomAlertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        bottomAlertSubject.eraseToAnyPublisher()
    }

    weak var screenListener: BankCardCreditCardLimitScreenListener?
    private var disposeBag = Set<AnyCancellable>()
    private var toastSubject = PassthroughSubject<String, Never>()

    @Injected private var bankCardStore: ReadOnly<BankCard?>
    @Injected private var bankCardAction: BankCardAction

    var toast: AnyPublisher<String, Never> {
        toastSubject.eraseToAnyPublisher()
    }
    @Published var isSaveButtonDisabled: Bool = true

    @Published var dailyLimitText: String = ""
    @Published var dailyLimitTextState: ValidationState = .normal

    @Published var dailyOnlineLimitText: String = ""
    @Published var dailyOnlineLimitTextState: ValidationState = .normal

    var dailyLimit: Double {
        Double(dailyLimitText) ?? 0.0
    }

    var dailyOnlineLimit: Double {
        Double(dailyOnlineLimitText) ?? 0.0
    }

    var bankCard: BankCard {
        if let card = bankCardStore.value {
            return card
         }
        fatalError("There must be a BankCard in the store!")
    }

    var currency: String {
        MoneyViewModel.make(using: bankCard.posLimit.total).currency.symbol
    }

    var posLimit: BankCard.Limit {
        bankCard.posLimit
    }

    var vposLimit: BankCard.Limit {
        bankCard.vposLimit
    }

    var vposMoneyVM: MoneyViewModel {
        MoneyViewModel.make(using: vposLimit.total)
    }

    var posMoneyVM: MoneyViewModel {
        MoneyViewModel.make(using: posLimit.total)
    }

    var dailyLimitChanged: Bool {
        dailyLimit != bankCard.posLimit.total.value.doubleValue
    }

    init() {

        populateCardLimit()

        $dailyLimitText
            .receive(on: DispatchQueue.main)
            .map { [bankCard] newValue -> ValidationState in

                let dailyLimit = Double(newValue) ?? 0.0

                if dailyLimit < bankCard.posLimit.min.value.doubleValue {
                    let minValue = bankCard.posLimit.min.localizedString
                    return .error(text: Strings.Localizable.bankCardLimitCreditCardMinErrorToken(minValue))
                } else if dailyLimit > bankCard.posLimit.max.value.doubleValue {
                    let maxValue = bankCard.posLimit.max.localizedString
                    return .error(text: Strings.Localizable.bankCardLimitCreditCardMaxError(maxValue))
                } else {
                    return .normal
                }
            }
            .assign(to: &$dailyLimitTextState)

        $dailyLimitTextState
            .receive(on: DispatchQueue.main)
            .map { [weak self] dailyState -> Bool in
                dailyState == .normal && self?.dailyLimitChanged == true
            }
            .map { !$0 }
            .assign(to: &$isSaveButtonDisabled)
    }

    private func populateCardLimit() {

        dailyLimitText = String(describing: bankCard.posLimit.total.value)
        dailyOnlineLimitText = String(describing: bankCard.vposLimit.total.value)
    }

    private func saveCreditCardLimits() {

        var pos: Double?
        if dailyLimitChanged {
            pos = dailyLimit
        }

        bankCardAction.changeBankCardLimit(cashWithdrawal: nil, pos: pos, vpos: nil)
        .sink { [weak self] completion in
            switch completion {
            case .finished:
                self?.handleSuccessChange()
            case .failure(let error):
                switch error {
                case .secondLevelAuth:
                    break
                default:
                    self?.handleError()
                }
            }
        }
        .store(in: &disposeBag)
    }

    func handleSuccessChange() {

        toastSubject.send(Strings.Localizable.bankCardLimitCreditCardDailyLimitChanged)

        dailyLimitTextState = .normal
    }

    func handleError() {
        self.bottomAlertSubject.send(.init(
            title: Strings.Localizable.bankCardLimitSetFailed,
            imageName: .alertSemantic,
            subtitle: Strings.Localizable.commonPleaseRetry,
            actions: [
                .init(title: Strings.Localizable.commonCancel,
                      kind: .secondary,
                      handler: { self.screenListener?.limitChangeCancelled() }),
                .init(title: Strings.Localizable.commonStartAgain,
                      handler: { self.populateCardLimit() })
            ]
       ))
    }

    func handle(event: BankCardCreditCardLimitScreenInput) {
        switch event {
        case .onSave:
            saveCreditCardLimits()
        case .dailyOnlineLimitInfo:
            screenListener?.creditCardOnlineLimitInfoRequested()
        }
    }
}
