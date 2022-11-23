//
//  VerifyPinViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 16..
//

import Combine
import Resolver

class VerifyPinViewModel: BasePinEnterScreenViewModel {
    @Injected var userAction: UserAction

    var onDeinit: (() -> Void)?
    var onPinVerified: ((PinCode) -> Void)?
    var onForceLogout: (() -> Void)?

    var method: ((PinCode) -> AnyPublisher<Never, ActionError<PinVerificationError>>)?

    deinit {
        onDeinit?()
    }

    override func onPinEntered(pin: PinCode) {
        pinState = .disabled
        method?(pin)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.pinError = nil
                    self?.pinState = .editing
                    self?.pin = []
                    self?.onPinVerified?(pin)
                case .failure(let error):
                    if case .action(let actionError) = error {
                        self?.showOTPError(error: actionError)
                    } else {
                        self?.showGenericError()
                    }
                }
            })
            .store(in: &disposeBag)
    }

    private func showOTPError(error: PinVerificationError) {
        switch error {
        case .invalidPin(remainingAttempts: let attempts):
            showError(message: AttributedString(Strings.Localizable.genericAuthenticationError(attempts)))
        case .forceLogout:
            onForceLogout?()
            userAction.logout().fireAndForget()
        }
    }
}
