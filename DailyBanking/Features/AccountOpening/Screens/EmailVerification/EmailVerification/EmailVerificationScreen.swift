//
//  EmailValidationScreen.swift
//  DailyBanking
//
//  Created by ALi on 2022. 04. 21..
//

import SwiftUI
import Combine
import DesignKit

protocol EmailVerificationScreenViewModelProtocol: ObservableObject {
    var email: String { get }
    var actionSheet: AnyPublisher<ActionSheetModel, Never> { get }
    var isAlterButtonDisabled: Bool { get }
    var errorDisplay: ResultModel? { get }
    var emailTimeRemaining: CountDownTimer.TimeRemaining { get }

    func handle(event: EmailVerificationScreenInput)
}

enum EmailVerificationScreenInput {
    case openEmailClient
    case showEmailActions
}

struct EmailVerificationScreen<ViewModel: EmailVerificationScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    let title: String = Strings.Localizable.consentsStartPageTitle

    var body: some View {
        FormLayout {
            VStack(spacing: 0) {
                Image(.emailNeutral)
                    .resizable()
                    .frame(width: 72, height: 72)
                    .padding(.bottom, .xl)
                Text(Strings.Localizable.emailVerificationSubtitle)
                    .textStyle(.headings3.thin)
                    .foregroundColor(.text.primary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, .s)
                Text(viewModel.email)
                    .textStyle(.headings4)
                    .foregroundColor(.text.secondary)
                    .padding(.bottom, .s)
                Text(Strings.Localizable.emailVerificationText)
                    .textStyle(.body1.condensed)
                    .foregroundColor(.text.tertiary)
                    .multilineTextAlignment(.center)
                DesignButton(
                    style: .tertiary,
                    title: Strings.Localizable.emailVerificationHaveNotGotEmail) {
                        viewModel.handle(event: .showEmailActions)
                    }
                    .padding(.vertical, .xl)
                    .disabled(viewModel.emailTimeRemaining.total > 0)
                if viewModel.emailTimeRemaining.total > 0 {
                    Text(Strings.Localizable.emailVerificationOperationsBlocked(viewModel.emailTimeRemaining.localized))
                        .textStyle(.body2)
                        .foregroundColor(.text.primary)
                        .padding(.horizontal, .s)
                }
            }
            .padding(.horizontal, .xxxl)
            .animation(.fast, value: viewModel.emailTimeRemaining.total)
        } floater: {
            DesignButton(
                style: .primary,
                title: Strings.Localizable.emailVerificationPrimaryButton) {
                    viewModel.handle(event: .openEmailClient)
                }
                .disabled(viewModel.isAlterButtonDisabled)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background.secondary)
        .actionSheet(viewModel.actionSheet)
        .fullscreenResult(model: viewModel.errorDisplay)
        .analyticsScreenView("registration_confirm_e-mail")
    }
}

struct EmailVerificationScreen_Previews: PreviewProvider {
    class PreviewViewModel: EmailVerificationScreenViewModelProtocol {
        var emailTimeRemaining: CountDownTimer.TimeRemaining = .init(total: 25)
        var errorDisplay: ResultModel?
        var email: String = "ali@me.com"
        var actionSheet: AnyPublisher<ActionSheetModel, Never> {
            PassthroughSubject<ActionSheetModel, Never>().eraseToAnyPublisher()
        }
        var isAlterButtonDisabled: Bool = false
        func handle(event: EmailVerificationScreenInput) {

        }
    }

    static var previews: some View {
        EmailVerificationScreen(viewModel: PreviewViewModel())
            .previewDevice("iPhone 13 mini")
    }
}
