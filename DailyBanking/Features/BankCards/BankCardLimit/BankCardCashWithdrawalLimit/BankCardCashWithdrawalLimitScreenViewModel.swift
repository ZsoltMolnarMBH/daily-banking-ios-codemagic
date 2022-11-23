//
//  BankCardCashWithdrawlLimitScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 10..
//

import Foundation
import AnyFormatKit
import Combine
import DesignKit
import Resolver

protocol BankCardCashWithdrawalLimitScreenListener: AnyObject {
    func limitChangeCancelled()
}

class BankCardCashWithdrawalLimitScreenViewModel: BankCardCashWithdrawalLimitScreenViewModelProtocol {

    var bottomAlertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        bottomAlertSubject.eraseToAnyPublisher()
    }

    weak var screenListener: BankCardCashWithdrawalLimitScreenListener?

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

    var bankCard: BankCard {
        if let card = bankCardStore.value {
            return card
         }
        fatalError("There must be a BankCard in the store!")
    }

    var cashWithdrawalLimit: BankCard.Limit {
        bankCard.cashWithdrawalLimit
    }

    var cashWithdrawalMoneyVM: MoneyViewModel {
        return MoneyViewModel.make(using: cashWithdrawalLimit.total)
    }

    var dailyLimit: Double {
        Double(dailyLimitText) ?? 0.0
    }

    init() {

        populateDailyLimitText()

        $dailyLimitText
            .receive(on: DispatchQueue.main)
            .map { [cashWithdrawalLimit] newValue -> ValidationState in
                let dailyLimit = Double(newValue) ?? 0.0

                if dailyLimit < cashWithdrawalLimit.min.value.doubleValue {
                    let minValue = cashWithdrawalLimit.min.localizedString
                    return .error(text: Strings.Localizable.bankCardLimitCashWithdrawalMinError(minValue))
                } else if dailyLimit > cashWithdrawalLimit.max.value.doubleValue {
                    let maxValue = cashWithdrawalLimit.max.localizedString
                    return .error(text: Strings.Localizable.bankCardLimitCashWithdrawalMaxError(maxValue))
                } else {
                    return .normal
                }
            }
            .assign(to: &$dailyLimitTextState)

        $dailyLimitTextState
            .receive(on: DispatchQueue.main)
            .map { [weak self] state -> Bool in
                state == .normal && self?.dailyLimit != self?.bankCard.cashWithdrawalLimit.total.value.doubleValue
            }
            .map { !$0 }
            .assign(to: &$isSaveButtonDisabled)
    }

    private func saveCreditCardCashWithdrawalLimit() {
        isSaveButtonDisabled = true

        bankCardAction.changeBankCardLimit(cashWithdrawal: dailyLimit, pos: nil, vpos: nil)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.toastSubject.send(Strings.Localizable.bankCardLimitCashWithdrawalChanged)

                    self?.isSaveButtonDisabled = true
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
                      handler: { self.populateDailyLimitText() })
            ]
       ))

        isSaveButtonDisabled = true
    }

    func populateDailyLimitText() {
        dailyLimitText = String(describing: cashWithdrawalLimit.total.value)
    }

    func handle(event: BankCardCashWithdrawalLimitScreenInput) {
        switch event {
        case .onSave:
            saveCreditCardCashWithdrawalLimit()
        }
    }
}
