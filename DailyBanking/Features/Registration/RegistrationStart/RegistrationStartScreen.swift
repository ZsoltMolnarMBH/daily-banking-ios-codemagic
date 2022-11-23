//
//  RegistrationStartScreen.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 22..
//

import Combine
import DesignKit
import Foundation
import SwiftUI

protocol RegistrationStartScreenViewModelProtocol: ObservableObject {
    var phoneFieldState: PhoneNumberValidity { get }
    var emailFieldState: ValidationState { get }
    var phonePrefix: String { get }
    var phoneNumber: String { get set }
    var email: String { get set }
    var isPhoneNumberCapableForRegistration: Bool { get }
    var fieldsAreValid: Bool { get }
    var termsURL: String { get }
    var privacyURL: String { get }
    var tcAccepted: Bool { get set }
    var privacyAccepted: Bool { get set }

    func handle(event: RegistrationStartScreenInput)
}

enum RegistrationStartScreenInput {
    case emailInfoPressed
    case phoneInfoPressed
    case proceed
    case tcSelected
    case privacySelected
}

struct RegistrationStartScreen<ViewModel: RegistrationStartScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: .xl) {
                Spacer()
                RegistrationStartStaticView()
                RegistrationStartTextFields(
                    viewModel: viewModel
                )
                RegistrationStartCheckBoxesView(
                    viewModel: viewModel
                )
                .onChange(of: viewModel.tcAccepted) { _ in
                    hideKeyboard()
                }
                .onChange(of: viewModel.privacyAccepted) { _ in
                    hideKeyboard()
                }
                Spacer()
            }
            .padding(.horizontal, .xxl)
        } floater: {
            RegistrationStartActionView(viewModel: viewModel)
        }
        .animation(.fast, value: viewModel.isPhoneNumberCapableForRegistration)
        .onTapGesture { hideKeyboard() }
        .background(Color.background.secondary)
        .analyticsScreenView("registration_add_phone_number")
    }
}

private class MockViewModel: RegistrationStartScreenViewModelProtocol {
    var termsURL = ""
    var privacyURL = ""
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

struct RegistrationStartScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegistrationStartScreen(viewModel: MockViewModel())
                .preferredColorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            RegistrationStartScreen(viewModel: MockViewModel())
                .preferredColorScheme(.light)
        }
    }
}
