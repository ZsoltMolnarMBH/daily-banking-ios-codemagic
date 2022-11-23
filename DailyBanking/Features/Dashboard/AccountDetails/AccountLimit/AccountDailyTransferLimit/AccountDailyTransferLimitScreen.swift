//
//  AccountDailyTransferLimitScreen.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 21..
//

import SwiftUI
import DesignKit
import Combine

protocol AccountDailyTransferLimitScreenViewModelProtocol: ObservableObject {
    var dailyLimitText: String { get set }
    var dailyLimitTextState: ValidationState { get set }
    var isSaveButtonDisabled: Bool { get }
    var maxLimit: Money { get }
    var currency: String { get }
    var toast: AnyPublisher<String, Never> { get }
    var bottomAlert: AnyPublisher<AlertModel, Never> { get }

    func handle(event: AccountDailyTransferLimitScreenInput)
}

enum AccountDailyTransferLimitScreenInput {
    case onSave
}

struct AccountDailyTransferLimitScreen<ViewModel: AccountDailyTransferLimitScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            Card {
                DesignTextField(
                    title: Strings.Localizable.accountTransactionLimitDailyTransferLabel,
                    suffix: viewModel.currency,
                    text: $viewModel.dailyLimitText,
                    hint: Strings.Localizable.accountTransactionLimitDailyTransferMax(viewModel.maxLimit.localizedString),
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
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Spacer().frame(height: .xl)
        }
        .toast(viewModel.toast)
        .designAlert(viewModel.bottomAlert)
        .background(Color.background.secondary)
        .animation(.fast, value: viewModel.dailyLimitTextState)
    }
}

struct AccountDailyTransferLimitScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountDailyTransferLimitScreen(viewModel: MockAccountDailyTransferLimitScreenViewModel())
    }
}

class MockAccountDailyTransferLimitScreenViewModel: AccountDailyTransferLimitScreenViewModelProtocol {

    var dailyLimitText: String = ""
    var dailyLimitTextState: ValidationState = .normal
    var isSaveButtonDisabled: Bool = true
    var maxLimit: Money = Money(value: 500_000, currency: "HUF")
    var currency: String = "FT"
    var toast: AnyPublisher<String, Never> = Empty<String, Never>().eraseToAnyPublisher()
    var bottomAlert: AnyPublisher<AlertModel, Never> = Empty<AlertModel, Never>().eraseToAnyPublisher()

    func handle(event: AccountDailyTransferLimitScreenInput) {}
}
