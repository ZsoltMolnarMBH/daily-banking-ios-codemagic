//
//  WaitingForSMSSCreen.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 28..
//

import Combine
import DesignKit
import Foundation
import SwiftUI

protocol RegistrationOTPScreenViewModelProtocol: ObservableObject {
    var smsOTP: String { get set }
    var smsFieldState: ValidationState { get }
    var expiration: TimeInterval { get }
    var responseTime: Date { get }
    var phoneNumber: String { get }
    var isCodeExpired: Bool { get }
    var resultModel: ResultModel? { get }
    var toast: AnyPublisher<String, Never> { get }
    var bottomAlert: AnyPublisher<AlertModel, Never> { get }
    var requestingSMS: Bool { get }

    var codeExpirationRemaining: CountDownTimer.TimeRemaining { get }
    var smsTimeRemaining: CountDownTimer.TimeRemaining { get }

    func handle(_ event: RegistrationOTPScreenInput)
}

enum RegistrationOTPScreenInput {
    case resendOtp
}

struct RegistrationOTPScreen<ViewModel: RegistrationOTPScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: 0) {
                Group {
                    progressView

                    Text(viewModel.codeExpirationRemaining.localized)
                        .textStyle(.headings3.thin)
                        .foregroundColor(.text.primary)
                        .padding(.horizontal, .s)
                        .padding([.top], .xl)
                }
                .fixedSize(horizontal: true, vertical: true)

                VStack(spacing: .xxs) {
                    Text(Strings.Localizable.registrationOtpPhoneNumberInfo(viewModel.phoneNumber))
                        .multilineTextAlignment(.center)
                        .lineSpacing(.xxs)
                }
                .textStyle(.body1)
                .foregroundColor(.text.secondary)
                .padding([.top], .s)

                DesignTextField(
                    title: Strings.Localizable.registrationOtpOtpInputTitle,
                    text: $viewModel.smsOTP,
                    validationState: viewModel.smsFieldState
                )
                .hideErrorWhileEditing(false)
                .onReceive(Just(viewModel.smsOTP)) { value in
                    let text = String(value.prefix(6))
                    guard value != text else { return }
                    viewModel.smsOTP = text
                }
                .textContentType(.oneTimeCode)
                .keyboardType(.numberPad)
                .submitLabel(.send)
                .padding([.top], .xl)

                DesignButton(
                    style: .tertiary,
                    width: .fluid,
                    title: Strings.Localizable.registrationOtpNewCodeRequest,
                    action: {
                        viewModel.handle(.resendOtp)
                    })
                .disabled(viewModel.smsTimeRemaining.total > 0 || viewModel.requestingSMS)
                    .padding(.top, 40)

                if viewModel.smsTimeRemaining.total > 0 {
                    Text(viewModel.smsTimeRemaining.localized)
                        .textStyle(.headings6)
                        .foregroundColor(.text.secondary)
                        .padding(.horizontal, .s)
                        .padding([.top], .m)
                }
            }
            .padding(.horizontal, .xxxl)
            .animation(.fast, value: viewModel.smsTimeRemaining.total > 0)
        } floater: { EmptyView() }
        .floaterAttachedToKeyboard(false)
        .fullscreenResult(model: viewModel.resultModel)
        .designAlert(viewModel.bottomAlert)
        .toast(viewModel.toast)
    }

    var progressView: some View {
        ZStack {
            CountDownView(
                countDownTime: viewModel.expiration,
                startedAt: viewModel.responseTime
            )
            Image(.shieldLocked)
                .resizable()
                .frame(width: 72, height: 72)
                .cornerRadius(10)
        }
    }
}

private class MockViewModel: RegistrationOTPScreenViewModelProtocol {
    var smsOTP: String = ""
    var smsFieldState: ValidationState = .normal
    var expiration: TimeInterval = 120
    var responseTime: Date = Date()
    var phoneNumber: String = "+36 20 3 203 206"
    var isCodeExpired: Bool = false
    var showModal: Bool = true
    var toast = PassthroughSubject<String, Never>().eraseToAnyPublisher()
    var bottomAlert = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()
    var resultModel: ResultModel?
    var requestingSMS: Bool = true

    var codeExpirationRemaining: CountDownTimer.TimeRemaining = .init(total: 120)
    var smsTimeRemaining: CountDownTimer.TimeRemaining = .init(total: 28)

    func handle(_ event: RegistrationOTPScreenInput) {}
}

struct RegsitrationSMSScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationOTPScreen(viewModel: MockViewModel())
            .preferredColorScheme(.light)
    }
}
