//
//  RegistrationStartTextViews.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import Combine
import DesignKit
import Foundation
import SwiftUI

struct RegistrationStartTextFields<ViewModel: RegistrationStartScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState var phoneFocused: Bool
    @FocusState var emailFocused: Bool

    var body: some View {
        VStack(spacing: .m) {
            DesignTextField(
                title: Strings.Localizable.registrationStartPhoneNumberTitle,
                prefix: viewModel.phonePrefix,
                text: $viewModel.phoneNumber,
                infoButtonImageAction: {
                    viewModel.handle(event: .phoneInfoPressed)
                },
                editor: .custom(factory: { $0.makePhoneNumberEditor }),
                validationState: viewModel.phoneFieldState.validationState
            )
            .hideErrorBeforeEditing(true)
            .hideErrorWhileEditing(viewModel.phoneFieldState != .notAllowed)
            .focused($phoneFocused)
            .textContentType(.telephoneNumber)
            .keyboardType(.numberPad)

            if viewModel.isPhoneNumberCapableForRegistration {
                DesignTextField(
                    title: Strings.Localizable.registrationStartEmailTitle,
                    text: $viewModel.email,
                    infoButtonImageAction: {
                        viewModel.handle(event: .emailInfoPressed)
                    },
                    validationState: viewModel.emailFieldState
                )
                .hideErrorBeforeEditing(true)
                .hideErrorWhileEditing(true)
                .focused($emailFocused)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .submitLabel(.continue)
            }
        }
    }
}

private extension PhoneNumberValidity {
    var validationState: ValidationState {
        switch self {
        case .badFormat:
            return .error(text: Strings.Localizable.commonErrorWrongNumber)
        case .notAllowed:
            return .error(text: Strings.Localizable.registrationStartErrorPhoneNumberInUse)
        case .loading:
            return .loading
        case .normal:
            return .normal
        case .success:
            return .validated
        }
    }
}

private class MockViewModel: RegistrationStartScreenViewModelProtocol {
    var termsURL: String = ""
    var privacyURL: String = ""
    var phonePrefix: String = "+36"
    var phoneNumber: String = "203203206"
    var email: String = "coolguy@me.com"
    var isPhoneNumberCapableForRegistration = true
    var fieldsAreValid: Bool = true
    var phoneFieldState: PhoneNumberValidity = .badFormat
    var emailFieldState: ValidationState = .normal
    var tcAccepted = false
    var privacyAccepted = true

    func handle(event: RegistrationStartScreenInput) {}
}

struct RegistrationStartTextFields_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RegistrationStartTextFields(viewModel: MockViewModel())
        }
    }
}
