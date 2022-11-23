//
//  PinCreationScreenViewModel.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 11. 09..
//

import Combine
import Resolver

class PinCreationScreenViewModel: BasePinCreationScreenViewModel {
    @Injected private var action: RegisterAction
    @Injected private var registrationDraft: ReadOnly<RegistrationDraft>

    override init() {
        super.init()
        $firstPin
            .combineLatest(registrationDraft.publisher)
            .map { code, draft -> String in
                let isRegistration = draft.flowKind == .registration
                let screenNameForFirstPin = isRegistration ? "registration_6digit_pin" : "device_activation_6digit_pin"
                let screenNameForSecondPin = isRegistration ? "registration_pin_confirmation" : "device_activation_pin_confirmation"
                return code == nil ? screenNameForFirstPin : screenNameForSecondPin
            }
            .assign(to: \.analyticsName, onWeak: self)
            .store(in: &disposeBag)
    }

    override func finish(pin: PinCode) {
        isLoading = true
        action.setupDeviceAuthentication(pin: pin)
            .sink { [weak self] event in
                self?.isLoading = false
                switch event {
                case .finished:
                    self?.events.send(.finishedPinCreation(pin))
                case .failure:
                    let cancel = AlertModel.Action(title: Strings.Localizable.commonCancel) { [weak self] in
                        self?.firstPin = nil
                        self?.pin = []
                        self?.pinState = .editing
                        self?.pinError = nil
                    }
                    let retry = AlertModel.Action(title: Strings.Localizable.commonRetry) { [weak self] in
                        self?.finish(pin: pin)
                    }
                    let alert = AlertModel(
                        title: "Hiba!", // There is no translation because this is not the official error handling solution
                        subtitle: AttributedString(Strings.Localizable.commonGenericErrorRetry),
                        actions: [cancel, retry]
                    )
                    self?.alert = alert
                }
            }
            .store(in: &disposeBag)
    }
}
