//
//  LoginEnterPinViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 26..
//

import Combine
import Resolver

class LoginEnterPinScreenViewModel: BasePinEnterScreenViewModel {
    @Injected var action: LoginAction
    var onShowDeviceReset: (() -> Void)?

    override func onPinEntered(pin: PinCode) {
        pinState = .disabled
        action
            .login(pin: pin)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if case .action(let loginError) = error {
                        self?.showAuthError(loginError)
                    } else {
                        self?.showGenericError()
                    }
                }
            })
            .store(in: &disposeBag)
    }

    private func showAuthError(_ error: LoginError) {
        switch error {
        case .invalidPin(let remaining):
            let message = Strings.Localizable.loginAuthenticationError(remaining)
            showError(message: try? AttributedString(markdown: message))
        case .temporaryBlocked(let blockedTime):
            pin = []
            bottomAlertSubject.send(.init(
                title: Strings.Localizable.loginAuthErrorDialogTitle,
                imageName: .alertSemantic,
                subtitle: try? AttributedString(
                    markdown: Strings.Localizable.loginTooManyErrorDescriptionIos(blockedTime),
                    options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
                ),
                actions: [.init(title: Strings.Localizable.commonAllRight, handler: {})]
            ))
            startTemporaryBlockCoolDown(minutes: blockedTime)
        case .deviceActivationRequired:
            pinState = .disabled
            onShowDeviceReset?()
            reset()
        default:
            showGenericError()
        }
    }

    private func startTemporaryBlockCoolDown(minutes: Int) {
        pinState = .error
        CountDownTimer(duration: Double(minutes * 60))
            .sink(receiveCompletion: { [weak self] _ in
                self?.pinState = .editing
                self?.pinError = nil
            }, receiveValue: { [weak self] time in
                let message = Strings.Localizable.commonErrorRetryAfterIos(time.localized)
                self?.pinError = try? AttributedString(markdown: message)
            })
            .store(in: &disposeBag)
    }
}
