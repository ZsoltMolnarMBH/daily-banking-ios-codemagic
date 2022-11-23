//
//  AccountDailyTransferLimitScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 21..
//

import Foundation
import AnyFormatKit
import Combine
import DesignKit
import Resolver

class AccountDailyTransferLimitScreenViewModel: AccountDailyTransferLimitScreenViewModelProtocol {
    private var disposeBag = Set<AnyCancellable>()
    private var toastSubject = PassthroughSubject<String, Never>()
    private var bottomAlertSubject = PassthroughSubject<AlertModel, Never>()

    @Injected private var accountStore: ReadOnly<Account?>
    @Injected private var accountAction: AccountAction

    var toast: AnyPublisher<String, Never> {
        toastSubject.eraseToAnyPublisher()
    }
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        bottomAlertSubject.eraseToAnyPublisher()
    }

    @Published var dailyLimitText: String = ""
    @Published var dailyLimitTextState: ValidationState = .normal
    @Published var isSaveButtonDisabled: Bool = true

    var account: Account {
        if let account = accountStore.value {
            return account
         }
        fatalError("There must be an Account in the store!")
    }

    var maxLimit: Money {
        return Money(value: Decimal(account.limits.dailyTransferLimit.max), currency: account.currency)
    }

    var currency: String {
        MoneyViewModel.make(using: maxLimit).currency.symbol
    }

    var minLimit: Money {
        Money(value: Decimal(account.limits.dailyTransferLimit.min), currency: account.currency)
    }

    var dailyLimitNumber: Int { Int(dailyLimitText) ?? 0 }
    var originalLimitValue: Int {
        account.limits.dailyTransferLimit.value
    }

    init() {
        $dailyLimitText
            .receive(on: DispatchQueue.main)
            .map { [weak self] newValue -> ValidationState in
                guard let self = self else { return .normal }
                let dailyLimit = Int(newValue) ?? 0
                let minLimit = Int(self.minLimit.value.doubleValue)
                let maxLimit = Int(self.maxLimit.value.doubleValue)

                if dailyLimit <=  minLimit {
                    return .error(text: Strings.Localizable.accountTransactionLimitDailyTransferMinError(self.minLimit.localizedString))
                } else if dailyLimit > maxLimit {
                    return .error(text: Strings.Localizable.accountTransactionLimitDailyTransferMaxError(self.maxLimit.localizedString))
                } else {
                    return .normal
                }

            }
            .assign(to: &$dailyLimitTextState)

        $dailyLimitTextState
            .receive(on: DispatchQueue.main)
            .map { [weak self] state -> Bool in
                state == .normal && self?.dailyLimitNumber != self?.originalLimitValue
            }
            .map { !$0 }
            .assign(to: &$isSaveButtonDisabled)

        populate()
    }

    private func populate() {
        let dailyLimitString = String(account.limits.dailyTransferLimit.value)
        dailyLimitText = dailyLimitString
    }

    private func saveAccountLimit() {
        accountAction.setLimit(
            on: account,
            limitValue: dailyLimitNumber,
            limitName: .dailyTransferLimit
        ).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                self?.isSaveButtonDisabled = true
                self?.toastSubject.send(Strings.Localizable.accountTransactionLimitDailyTransferLimitChanged)
            case .failure(let error):
                if case .secondLevelAuth = error { return }
                self?.bottomAlertSubject.send(
                    .init(
                        title: Strings.Localizable.accountLimitSetFailed,
                        imageName: .alertSemantic,
                        subtitle: Strings.Localizable.commonPleaseRetry,
                        actions: [
                            .init(title: Strings.Localizable.commonCancel, kind: .secondary, handler: {}),
                            .init(title: Strings.Localizable.commonRetry, handler: { [weak self] in
                                self?.saveAccountLimit()
                            })
                        ]
                    )
                )
            }
        })
        .store(in: &disposeBag)
    }

    func handle(event: AccountDailyTransferLimitScreenInput) {
        switch event {
        case .onSave:
            saveAccountLimit()
        }
    }
}
