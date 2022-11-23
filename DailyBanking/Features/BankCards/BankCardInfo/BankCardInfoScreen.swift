//
//  BankCardInfoScreen.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 25..
//

import SwiftUI
import DesignKit
import Combine

protocol BankCardInfoScreenViewModelProtocol: ObservableObject {
    var name: String { get }
    var cardNumber: String { get }
    var cvc: String { get }
    var valid: String { get }
    var toast: AnyPublisher<String, Never> { get }
    var timeCounterText: AttributedString { get }

    func handle(event: BankCardInfoScreenInput)
}

enum BankCardInfoScreenInput {
    case copyBankCardNumber
    case close
}

struct BankCardInfoScreen<ViewModel: BankCardInfoScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: .xl) {
            Text(Strings.Localizable.bankCardInfoTitle)
                .textStyle(.headings5)
                .foregroundColor(.text.tertiary)
            InfoView(title: Strings.Localizable.bankCardInfoOwnerName, text: viewModel.name, secure: true)
            Button.init {
                viewModel.handle(event: .copyBankCardNumber)
            } label: {
                HStack {
                    InfoView(title: Strings.Localizable.bankCardInfoCardNumber, text: viewModel.cardNumber, secure: true)
                    Spacer()
                    Image(.fileCopy)
                        .foregroundColor(Color.text.tertiary)
                }
            }
            InfoView(title: Strings.Localizable.bankCardInfoCvcCode, text: viewModel.cvc, secure: true)
            InfoView(title: Strings.Localizable.bankCardInfoExpDate, text: viewModel.valid, secure: true)
            DesignButton(style: .primary, title: Strings.Localizable.commonClose) {
                viewModel.handle(event: .close)
            }
            HStack {
                Spacer()
                Text(viewModel.timeCounterText)
                    .textStyle(.body2)
                    .foregroundColor(.text.tertiary)
                Spacer()
            }
        }
        .toast(viewModel.toast)
    }
}

struct BankCardInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankCardInfoScreen(viewModel: MockBankCardInfoScreenViewModel())
    }
}

class MockBankCardInfoScreenViewModel: BankCardInfoScreenViewModelProtocol {
    var name: String = "Teszt Aladár"
    var cardNumber: String = "5454 1234 6373 6373"
    var cvc: String = "111"
    var valid: String = "07/24"
    var toast: AnyPublisher<String, Never> = Empty<String, Never>().eraseToAnyPublisher()
    var timeCounterText: AttributedString = "2:00"

    func handle(event: BankCardInfoScreenInput) {}
}
