//
//  BankCardCashWithdrawlLimitScreen.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 10..
//

import SwiftUI
import DesignKit
import Combine

protocol BankCardCashWithdrawalLimitScreenViewModelProtocol: ObservableObject {
    var dailyLimitText: String { get set }
    var dailyLimitTextState: ValidationState { get set }
    var isSaveButtonDisabled: Bool { get }
    var cashWithdrawalMoneyVM: MoneyViewModel { get }
    var cashWithdrawalLimit: BankCard.Limit { get }
    var toast: AnyPublisher<String, Never> { get }

    var bottomAlert: AnyPublisher<AlertModel, Never> { get }

    func handle(event: BankCardCashWithdrawalLimitScreenInput)
}

enum BankCardCashWithdrawalLimitScreenInput {
    case onSave
}

struct BankCardCashWithdrawalLimitScreen<ViewModel: BankCardCashWithdrawalLimitScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            Card {
                DesignTextField(
                    title: Strings.Localizable.bankCardLimitCashWithdrawalDalySum,
                    suffix: viewModel.cashWithdrawalMoneyVM.currency.symbol,
                    text: $viewModel.dailyLimitText,
                    hint: Strings.Localizable.bankCardLimitCashWithdrawalMax(viewModel.cashWithdrawalLimit.max.localizedString),
                    editor: .custom(factory: { $0.makeCurrencyHufEditorEditor }),
                    validationState: viewModel.dailyLimitTextState
                )
                .hideErrorWhileEditing(viewModel.dailyLimitText.isEmpty)
                .keyboardType(.numberPad)
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
        .analyticsScreenView("cash_withdrawal_limit")
        .designAlert(viewModel.bottomAlert)
    }
}

struct BankCardCashWithdrawalLimitScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankCardCashWithdrawalLimitScreen(viewModel: MockBankCardCashWithdrawalLimitScreenViewModel())
    }
}

class MockBankCardCashWithdrawalLimitScreenViewModel: BankCardCashWithdrawalLimitScreenViewModelProtocol {

    var bottomAlert: AnyPublisher<AlertModel, Never> = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()

    var isSaveButtonDisabled: Bool = true
    var dailyLimitText: String = ""
    var dailyLimitTextState: ValidationState = .normal
    var cashWithdrawalMoneyVM: MoneyViewModel = MoneyViewModel.make(using: .zeroHUF)
    var cashWithdrawalLimit: BankCard.Limit = BankCard.Limit(total: .zeroHUF, remaining: .zeroHUF, min: .zeroHUF, max: .zeroHUF)
    var toast: AnyPublisher<String, Never> = Empty<String, Never>().eraseToAnyPublisher()

    func handle(event: BankCardCashWithdrawalLimitScreenInput) {}
}
