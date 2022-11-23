//
//  AmountScreen.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 26..
//

import SwiftUI
import DesignKit
import Combine

protocol AmountScreenViewModelProtocol: ObservableObject {
    var amount: String { get set }
    var currency: CurrencyViewModel { get }
    var balanceAvailable: String { get }
    var fee: String { get }
    var error: String? { get }
    var isConfirmAvailable: Bool { get }
    func handle(event: AmountScreenInput)
}

enum AmountScreenInput {
    case confirm
}

struct AmountScreen<ViewModel: AmountScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var textFieldSize = CGSize()
    @State private var focusTrigger: Bool = true

    var body: some View {
        FormLayout(content: {
            VStack(alignment: .center) {
                Spacer()
                AmountInputView(text: $viewModel.amount)
                    .textStyle(.headings1)
                    .accentColor(.highlight.tertiary)
                    .isCurrencyPrefix(viewModel.currency.isPrefix)
                    .currencySymbol(viewModel.currency.symbol)
                    .currencyForegroundColor(.text.tertiary)
                    .currencySpacing(8)
                    .horizontalPadding(16)
                    .keyboardType(.numberPad)
                    .startAsFirstResponder()
                    .focusTrigger($focusTrigger)
                VStack(spacing: .xs) {
                    Text(viewModel.fee)
                        .textStyle(.body2)
                        .foregroundColor(.text.tertiary)
                    Text(viewModel.balanceAvailable)
                        .textStyle(.body2)
                        .foregroundColor(.text.tertiary)
                    if let error = viewModel.error {
                        Text(error)
                            .textStyle(.body2)
                            .foregroundColor(.error.highlight)
                    }
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, .xxl)
                Spacer()
            }
            .onTapGesture { focusTrigger.toggle() }
            .animation(.fast, value: viewModel.balanceAvailable)
            .animation(.fast, value: viewModel.error)
        }, floater: {
            DesignButton(title: Strings.Localizable.commonNext) {
                viewModel.handle(event: .confirm)
            }
            .disabled(!viewModel.isConfirmAvailable)
        })
        .formBackground(.background.primary)
        .floaterAttachedToKeyboard(true)
        .analyticsScreenView("new_transfer_amount")
    }
}

struct AmountScreen_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AmountScreen<AmountScreenViewModelMock>(viewModel: .init())
                .preferredColorScheme(.light)
        }
    }
}

class AmountScreenViewModelMock: AmountScreenViewModelProtocol {
    @Published var amount = "123 456 789"
    var currency = CurrencyViewModel(symbol: "Ft", isPrefix: false)
    var fee = "+ Tranzakciós díj: 123 Ft"
    var balanceAvailable = "Jelenleg elérhető egyenleg: 16 900 Ft"
    var isConfirmAvailable: Bool = true
    var error: String? = "Ehhez az átutaláshoz nincs elég pénz a bankszámláján."

    func handle(event: AmountScreenInput) {
    }
}
