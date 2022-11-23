//
//  BankCardCreditCardLimitScreen.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 08..
//

import SwiftUI
import DesignKit
import Combine

protocol BankCardCreditCardLimitScreenViewModelProtocol: ObservableObject {
    var dailyLimitText: String { get set }
    var dailyLimitTextState: ValidationState { get set }
    var dailyOnlineLimitText: String { get set }
    var dailyOnlineLimitTextState: ValidationState { get set }
    var isSaveButtonDisabled: Bool { get }
    var vposMoneyVM: MoneyViewModel { get }
    var posMoneyVM: MoneyViewModel { get }
    var posLimit: BankCard.Limit { get }
    var vposLimit: BankCard.Limit { get }

    var toast: AnyPublisher<String, Never> { get }

    var bottomAlert: AnyPublisher<AlertModel, Never> { get }

    func handle(event: BankCardCreditCardLimitScreenInput)
}

enum BankCardCreditCardLimitScreenInput {
    case onSave
    case dailyOnlineLimitInfo
}

struct BankCardCreditCardLimitScreen<ViewModel: BankCardCreditCardLimitScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            Card {
                DesignTextField(
                    title: Strings.Localizable.bankCardLimitCreditCardDailySum,
                    suffix: viewModel.posMoneyVM.currency.symbol,
                    text: $viewModel.dailyLimitText,
                    hint: Strings.Localizable.bankCardLimitCreditCardMax(viewModel.posLimit.max.localizedString),
                    editor: .custom(factory: { $0.makeCurrencyHufEditorEditor }),
                    validationState: viewModel.dailyLimitTextState
                )
                .hideErrorWhileEditing(viewModel.dailyLimitText.isEmpty)
                .keyboardType(.numberPad)

                VStack {
                    HStack {
                        DesignTextFieldHeader(
                            title: Strings.Localizable.bankCardLimitCreditCardOnlineSum,
                            infoButtonImageAction: {
                                viewModel.handle(event: .dailyOnlineLimitInfo)
                            })
                        Spacer()
                    }
                    DesignTextField(
                        suffix: viewModel.vposMoneyVM.currency.symbol,
                        text: $viewModel.dailyOnlineLimitText,
                        hint: Strings.Localizable.bankCardLimitCreditCardMax(viewModel.vposLimit.max.localizedString),
                        editor: .custom(factory: { $0.makeCurrencyHufEditorEditor }),
                        validationState: viewModel.dailyOnlineLimitTextState
                    )
                    .hideErrorWhileEditing(viewModel.dailyOnlineLimitText.isEmpty)
                    .keyboardType(.numberPad)
                    .disabled(true)
                }
            }
            .padding()
            Spacer()
        } floater: {
            DesignButton(style: .primary, width: .fullSize, title: Strings.Localizable.commonSetItUp) {
                viewModel.handle(event: .onSave)
                hideKeyboard()
            }
            .disabled(viewModel.isSaveButtonDisabled)
        }
        .floaterAttachedToKeyboard(true)
        .toast(viewModel.toast)
        .background(Color.background.secondary)
        .analyticsScreenView("bank_card_limit")
        .designAlert(viewModel.bottomAlert)
    }
}

struct BankCardCreditCardLimitScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankCardCreditCardLimitScreen(viewModel: MockBankCardCreditCardLimitScreenViewModel())
    }
}

class MockBankCardCreditCardLimitScreenViewModel: BankCardCreditCardLimitScreenViewModelProtocol {

    var bottomAlert: AnyPublisher<AlertModel, Never> = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()

    var posLimit: BankCard.Limit = BankCard.Limit(total: .zeroHUF, remaining: .zeroHUF, min: .zeroHUF, max: .zeroHUF)

    var vposLimit: BankCard.Limit = BankCard.Limit(total: .zeroHUF, remaining: .zeroHUF, min: .zeroHUF, max: .zeroHUF)

    var vposMoneyVM: MoneyViewModel = MoneyViewModel.make(using: .zeroHUF)

    var posMoneyVM: MoneyViewModel = MoneyViewModel.make(using: .zeroHUF)

    var isSaveButtonDisabled: Bool = true

    var dailyLimitText: String = ""
    var dailyLimitTextState: ValidationState = .normal

    var dailyOnlineLimitText: String = ""
    var dailyOnlineLimitTextState: ValidationState = .normal

    var toast: AnyPublisher<String, Never> = Empty<String, Never>().eraseToAnyPublisher()

    func handle(event: BankCardCreditCardLimitScreenInput) {}
}
