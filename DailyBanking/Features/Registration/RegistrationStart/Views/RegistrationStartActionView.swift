//
//  RegistrationStartActionView.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import DesignKit
import Foundation
import SwiftUI

struct RegistrationStartActionView<ViewModel: RegistrationStartScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 0) {
            DesignButton(
                style: .primary,
                title: Strings.Localizable.commonNext,
                action: { viewModel.handle(event: .proceed) }
            )
            .disabled(!viewModel.fieldsAreValid)
        }
    }
}

private class MockViewModel: RegistrationStartScreenViewModelProtocol {
    var termsURL: String = ""
    var privacyURL: String = ""
    var phonePrefix: String = "+36"
    func handle(event: RegistrationStartScreenInput) {}
    var phoneNumber: String = "203203206"
    var email: String = "coolguy@me.com"
    var isPhoneNumberCapableForRegistration = false
    var fieldsAreValid: Bool = true
    var phoneFieldState: PhoneNumberValidity = .badFormat
    var emailFieldState: ValidationState = .normal
    var tcAccepted = false
    var privacyAccepted = true
}

struct RegistrationStartActionView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationStartActionView(
            viewModel: MockViewModel()
        )
    }
}

struct RegistrationStartActionViewDark_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationStartActionView(
            viewModel: MockViewModel()
        )
        .preferredColorScheme(.dark)
    }
}
