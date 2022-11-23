//
//  BankCardPinCodeRevealScreen.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 26..
//

import SwiftUI
import DesignKit

protocol PinCodeRevealScreenViewModelProtocol: ObservableObject {
    var timeCounterText: AttributedString { get }
    var pinCode: String { get }

    func handle(event: PinCodeRevealScreenInput)
}

enum PinCodeRevealScreenInput {
    case close
}

struct PinCodeRevealScreen<ViewModel: PinCodeRevealScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: .xl) {
            Text(Strings.Localizable.bankCardPinCodeTitle)
                .textStyle(.headings5)
                .foregroundColor(.text.tertiary)
            HStack {
                Spacer()
                SecureLabel(text: viewModel.pinCode)
                    .textStyle(.headings1)
                    .foregroundColor(.text.primary)
                    .fixedSize()
                Spacer()
            }
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
    }
}

struct PinCodeRevealScreen_Previews: PreviewProvider {
    static var previews: some View {
        PinCodeRevealScreen(viewModel: MockPinCodeRevealScreenViewModel())
    }
}

class MockPinCodeRevealScreenViewModel: PinCodeRevealScreenViewModelProtocol {
    var pinCode: String = "1212"
    var timeCounterText: AttributedString = "2:00"

    func handle(event: PinCodeRevealScreenInput) {}
}
