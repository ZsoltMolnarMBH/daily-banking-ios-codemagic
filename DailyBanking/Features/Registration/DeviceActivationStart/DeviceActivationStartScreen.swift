//
//  DeviceActivationStartScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 29..
//

import Combine
import DesignKit
import SwiftUI

enum DeviceActivationScreenInput {
    case startDeviceActivation
    case help
}

protocol DeviceActivationStartScreenViewModelProtocol: ObservableObject {
    var phoneNumber: String { get set }
    var password: String { get set }
    var phoneFieldState: PhoneNumberValidity { get }
    var passwordFieldState: ValidationState { get }
    var isPhoneNumberCapableForActivation: Bool { get }
    var fieldsAreValid: Bool { get }
    var isBlocked: Bool { get }
    var activationErrorMessage: AttributedString? { get }
    var isLoading: Bool { get }
    var bottomAlert: AnyPublisher<AlertModel, Never> { get }
    var permamentBlockedModel: ResultModel? { get }

    func handle(event: DeviceActivationScreenInput)
}

struct DeviceActivationStartScreen<ViewModel: DeviceActivationStartScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState var phoneFocused: Bool

    @Namespace var textFields

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                Spacer()
                VStack(spacing: .m) {
                    Image(.smartphoneRegistration)
                        .resizable()
                        .frame(width: 72, height: 72)
                        .padding(.bottom, .xs)
                    Text(Strings.Localizable.deviceActivationTitle)
                        .foregroundColor(.text.primary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, .xs)
                        .textStyle(.headings3.thin)
                }
                if let message = viewModel.activationErrorMessage {
                    HStack(spacing: 0) {
                        Spacer()
                        Text(message)
                            .textStyle(.body2)
                            .padding(.m)
                            .foregroundColor(.error.secondary.foreground)
                        Spacer()
                    }
                    .background(Color.error.secondary.background)
                    .cornerRadius(10)
                }
                Group {
                    DesignTextField(
                        title: Strings.Localizable.deviceActivationInputPhoneNumberTitle,
                        prefix: "+36",
                        text: $viewModel.phoneNumber,
                        editor: .custom(factory: { $0.makePhoneNumberEditor }),
                        validationState: viewModel.phoneFieldState.validationState
                    )
                    .hideErrorWhileEditing(viewModel.phoneFieldState != .notAllowed)
                    .hideErrorBeforeEditing(true)
                    .disabled(viewModel.isBlocked)
                    .focused($phoneFocused)
                    .keyboardType(.numberPad)
                    .textContentType(.telephoneNumber)
                    .padding(.bottom, .m)

                    if viewModel.isPhoneNumberCapableForActivation {
                        DesignTextField(
                            title: Strings.Localizable.deviceActivationInputPasswordTitle,
                            text: $viewModel.password,
                            editor: .secured(onSubmit: {
                                hideKeyboard()
                                if isFormValid {
                                    viewModel.handle(event: .startDeviceActivation)
                                }
                            }),
                            validationState: viewModel.passwordFieldState
                        )
                        .disabled(viewModel.isBlocked)
                    }
                }

                if viewModel.isPhoneNumberCapableForActivation {
                    DesignButton(
                        style: .tertiary,
                        title: Strings.Localizable.deviceActivationHelp,
                        action: {
                            viewModel.handle(event: .help)
                        }
                    )
                    .padding(.top, .xl)
                }
                Spacer()
            }
            .padding(.top, .m)
            .padding(.horizontal, .xxxl)
            .animation(.fast, value: viewModel.activationErrorMessage)
            .animation(.fast, value: viewModel.isPhoneNumberCapableForActivation)
        } floater: {
            DesignButton(
                style: .primary,
                title: Strings.Localizable.commonNext,
                action: {
                    hideKeyboard()
                    viewModel.handle(event: .startDeviceActivation)
                }
            )
            .id(textFields)
            .disabled(!isFormValid)
        }
        .designAlert(viewModel.bottomAlert)
        .fullscreenResult(model: viewModel.permamentBlockedModel)
        .navigationBarBackButtonHidden(viewModel.isBlocked)
        .onTapGesture { hideKeyboard() }
        .fullScreenProgress(by: viewModel.isLoading, name: "deviceactivationstart")
        .background(Color.background.secondary)
        .analyticsScreenView("device_activation")
    }

    var isFormValid: Bool {
        viewModel.fieldsAreValid
        && viewModel.isPhoneNumberCapableForActivation
        && !viewModel.isBlocked
    }
}

private extension PhoneNumberValidity {
    var validationState: ValidationState {
         switch self {
         case .badFormat:
             return .error(text: Strings.Localizable.commonErrorWrongNumber)
         case .notAllowed:
             return .error(text: Strings.Localizable.deviceActivationPhoneNotFoundError)
         case .loading:
             return .loading
         case .normal:
             return .normal
         case .success:
             return .validated
         }
     }
}

private class MockViewModel: DeviceActivationStartScreenViewModelProtocol {
    var phoneFieldState: PhoneNumberValidity = .badFormat
    var passwordFieldState: ValidationState = .error(text: "")
    var isPhoneNumberCapableForActivation: Bool = true
    var fieldsAreValid: Bool = true
    var phoneNumber = "20 3 203 206"
    var password = "password"
    var activationErrorMessage: AttributedString? = "A mobilszám vagy a jelszó nem egyezik a regisztrációnál megadottal. Próbálja újra!"
    var isLoading = false
    var isBlocked: Bool = false
    var bottomAlert: AnyPublisher<AlertModel, Never> = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()
    var permamentBlockedModel: ResultModel?

    func handle(event: DeviceActivationScreenInput) {}
}

struct DeviceActivationScreenPreviews: PreviewProvider {
    static var previews: some View {
        ZStack {
            DeviceActivationStartScreen(viewModel: MockViewModel())
                .preferredColorScheme(.light)
        }
    }
}
