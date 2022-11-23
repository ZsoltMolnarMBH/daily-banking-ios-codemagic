//
//  AlterEmailScreen.swift
//  DailyBanking
//
//  Created by ALi on 2022. 04. 24..
//

import SwiftUI
import DesignKit

protocol EmailAlterationScreenViewModelProtocol: ObservableObject {
    var emailAddress: String { get set }
    var emailState: ValidationState { get }
    var isAlterDisabled: Bool { get }
    var errorDisplay: ResultModel? { get }
    var isProcessing: Bool { get }

    func handle(event: EmailAlterationScreenInput)
}

enum EmailAlterationScreenInput {
    case alterEmail
}

struct EmailAlterationScreen<ViewModel: EmailAlterationScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        FormLayout {
            VStack {
                Card {
                    DesignTextField(
                        title: Strings.Localizable.accountSetupContactsEmail,
                        text: $viewModel.emailAddress,
                        validationState: viewModel.emailState
                    )
                    .hideErrorWhileEditing(true)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                }
                Spacer()
            }
            .padding()
        } floater: {
            DesignButton(
                style: .primary,
                title: Strings.Localizable.alterEmailAlterButton) {
                    self.viewModel.handle(event: .alterEmail)
                }
                .disabled(viewModel.isAlterDisabled)
        }
        .floaterAttachedToKeyboard(true)
        .fullScreenProgress(by: viewModel.isProcessing, name: "EmailAlterationScreen")
        .fullscreenResult(model: viewModel.errorDisplay, shouldHideNavbar: false)
        .analyticsScreenView("registration_modify_e-mail")
    }
}

struct AlterEmailScreen_Previews: PreviewProvider {
    private class ViewModel: EmailAlterationScreenViewModelProtocol {
        var emailAddress: String = "ali@me.com"
        var emailState: ValidationState = .normal
        let isAlterDisabled: Bool = true
        let isProcessing: Bool = false
        var errorDisplay: ResultModel?

        func handle(event: EmailAlterationScreenInput) { }
    }
    static var previews: some View {
        EmailAlterationScreen(viewModel: ViewModel())
    }
}
