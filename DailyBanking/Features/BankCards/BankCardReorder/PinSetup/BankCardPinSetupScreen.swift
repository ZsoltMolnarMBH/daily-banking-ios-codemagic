//
//  BankCardPinSetupScreen.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 25..
//

import SwiftUI
import DesignKit
import Combine

struct BankCardPinSetupScreen<ViewModel: BankCardPinSetupViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    @FocusState private var textFieldFocused: Bool

    var body: some View {
        VStack {
            Text(viewModel.pinSetupState.title)
                .textStyle(.body1)
                .foregroundColor(Color.text.secondary)
            ZStack {
                TextField("", text: $viewModel.pinText)
                    .background(Color.white)
                    .focused($textFieldFocused)
                    .keyboardType(.numberPad)
                    .onReceive(Just(viewModel.pinText)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            let text = String(filtered.prefix(4))
                            viewModel.pinText = text
                        }
                    }

                HStack(spacing: .xs) {
                    Spacer()
                    PinView(hasValue: viewModel.pinText.hasFirstPin, editing: viewModel.pinText.editingIndex == 0, state: viewModel.pinCodeState)
                    PinView(hasValue: viewModel.pinText.hasSecondPin, editing: viewModel.pinText.editingIndex == 1, state: viewModel.pinCodeState)
                    PinView(hasValue: viewModel.pinText.hasThirdPin, editing: viewModel.pinText.editingIndex == 2, state: viewModel.pinCodeState)
                    PinView(hasValue: viewModel.pinText.hasFourthPin, editing: viewModel.pinText.editingIndex == 3, state: viewModel.pinCodeState)
                    Spacer()
                }
                .background(Color.background.secondary)
                .onTapGesture {
                    textFieldFocused = true
                }
            }
            .padding(.top, .xs)
            if let error = viewModel.pinError {
                    Text(error)
                        .textStyle(.body2)
                        .foregroundColor(.error.highlight)
                        .multilineTextAlignment(.center)
                        .padding([.top, .bottom], .m)
                        .padding([.leading, .trailing], .xl)
            }
            DesignButton(style: .tertiary,
                         size: .large,
                         title: Strings.Localizable.pinSetupInfoHint) {
                textFieldFocused = false
                viewModel.handle(event: .showHint)
            }.padding(.top, viewModel.pinError == nil ? .xxl : 0)
            Spacer()
        }
        .padding(.top, 48)
        .background(Color.background.secondary)
        .onChange(of: viewModel.textFieldFocused) {
            textFieldFocused = $0     // << write !!
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                textFieldFocused = viewModel.textFieldFocused
            }
        }
        .navigationTitle(viewModel.pinSetupState.screenTitle)
        .animation(.default, value: viewModel.pinError)
        .fullScreenProgress(by: viewModel.isLoading, name: "reordeding")
        .fullscreenResult(model: viewModel.fullScreenResult)
        .designAlert(viewModel.bottomAlert)
    }
}

private extension String {

    var editingIndex: Int {
        return self.count
    }
    
    var hasFirstPin: Bool {
        return self.count > 0
    }

    var hasSecondPin: Bool {
        return self.count > 1
    }

    var hasThirdPin: Bool {
        return self.count > 2
    }
    var hasFourthPin: Bool {
        return self.count > 3
    }
}

private class MockViewModel: BankCardPinSetupViewModelProtocol {

    var bottomAlert: AnyPublisher<AlertModel, Never> = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()

    var isLoading: Bool = false

    var individual: Individual?

    var textFieldFocused: Bool = false

    var pinCodeState: PinCodeState = .editing

    var pinError: AttributedString?

    var pinSetupState: BankCardPinSetupState = .enterFirstPin

    var pinText: String = "2"

    var fullScreenResult: ResultModel?

    func handle(event: BankCardPinSetupScreenInput) { }
}
struct BankCardPinSetupScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankCardPinSetupScreen(viewModel: MockViewModel())
    }
}
