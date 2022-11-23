//
//  AmountScreenViewModel.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 27..
//

import Resolver
import Combine

class AmountScreenViewModel: ScreenViewModel<Money>, AmountScreenViewModelProtocol {
    static private let currencyCode = "HUF"

    private enum AmountError: Error {
        case zero
        case exceedingDailyLimit(Money)
        case insufficent
    }

    @Injected private var action: NewTransferAction
    @Injected private var config: NewTransferConfig
    @Injected private var account: ReadOnly<Account?>
    @Injected(name: .newTransfer.fee) private var transactionFee: ReadOnly<MoneyProcess?>
    @Injected(name: .newTransfer.limit) private var dailyLimit: ReadOnly<MoneyProcess?>
    private var currencyCode: String!

    @Published var amount: String = ""
    @Published var fee: String = ""
    var currency: CurrencyViewModel = .make(currencyCode: AmountScreenViewModel.currencyCode)
    @Published var isConfirmAvailable: Bool = false
    @Published var balanceAvailable: String = ""
    @Published var error: String?
    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()

        // Currency

        let currencyCode = account.value?.availableBalance.currency ?? Self.currencyCode
        self.currencyCode = currencyCode
        self.currency = .make(currencyCode: currencyCode)

        // Amount conversion

        let amountDecimal = $amount.map { $0.decimalValue }
        let amountValue = amountDecimal.map { NSDecimalNumber(decimal: $0).doubleValue }

        // Transaction fee

        let defaultFee = Money(value: 0, currency: currencyCode).localizedString
        fee = Strings.Localizable.newTransferTransactionFee(defaultFee)
        amountDecimal
            .debounce(for: .seconds(config.feeFetchDebounceTime), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { [action] amount in
                action.transactionFee(for: .init(
                    value: amount,
                    currency: currencyCode))
                .catch { _ in
                    Empty().eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .sink(receiveCompletion: { _ in })
            .store(in: &disposeBag)
        transactionFee.publisher
            .compactMap { $0?.localizedTransactionFee }
            .assign(to: &$fee)

        // Balance available

        account.publisher
            .map { account in
                guard let account = account else { return "" }
                return Strings.Localizable.newTransferAmountCurrentAmount(account.availableBalance.localizedString)
            }
            .assign(to: &$balanceAvailable)

        // Validating form

        let feeWithoutLoading = transactionFee.publisher
            .filter { $0?.isLoading != true }
            .map { $0?.get() }
        let amountError = Publishers.CombineLatest4(amountValue,
                                                    account.publisher,
                                                    feeWithoutLoading,
                                                    dailyLimit.publisher)
            .map { [config] amount, account, fee, limitRemaning -> AmountError? in
                guard config.isInlineValidationEnabled else { return nil }
                guard let availableBalance = account?.availableBalance, amount > 0 else {
                    return .zero
                }

                var cost = amount
                if let fee = fee, fee.currency == currencyCode {
                    cost += fee.value.doubleValue
                }
                if cost > availableBalance.value.doubleValue {
                    return .insufficent
                }
                if let limitRemaning = limitRemaning?.get(),
                    limitRemaning.currency == currencyCode,
                    amount > limitRemaning.value.doubleValue {
                    return .exceedingDailyLimit(limitRemaning)
                }
                return nil
            }
        amountError
            .map { error -> String? in
                switch error {
                case .none, .zero:
                    return nil
                case .exceedingDailyLimit(let limitRemaning):
                    return Strings.Localizable.newTransferAmountDailyLimitAmountError(limitRemaning.localizedString)
                case .insufficent:
                    return Strings.Localizable.newTransferAmountInsufficientError
                }
            }
            .assign(to: &$error)
        amountError
            .map { $0 == nil }
            .assign(to: &$isConfirmAvailable)
    }

    func handle(event: AmountScreenInput) {
        switch event {
        case .confirm:
            events.send(Money(value: amount.decimalValue, currency: currencyCode))
        }
    }
}
