//
//  PinChangeViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 16..
//

import Combine
import Resolver

class PinChangeViewModel: BasePinCreationScreenViewModel {
    @Injected private var action: UserAction
    var oldPin: PinCode?

    override init() {
        super.init()
        $firstPin
            .map { code -> String in
                code == nil ? "profile_new_pin" : "profile_pin_confirmation"
            }
            .assign(to: \.analyticsName, onWeak: self)
            .store(in: &disposeBag)
    }

    override func finish(pin: PinCode) {
        guard let oldPin = oldPin else { fatalError("old PinCode must be set") }
        isLoading = true
        action
            .changeMpin(from: oldPin, to: pin)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
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
                        title: "Hiba!",
                        subtitle: AttributedString(Strings.Localizable.commonGenericErrorRetry),
                        actions: [cancel, retry]
                    )
                    self?.alert = alert
                }
            }
            .store(in: &disposeBag)
    }

    override func validate(firstPin: PinCode?) -> NewPinError? {
        return self.pin.validate(requiredToMatch: firstPin, forbiddenToMatch: oldPin)
    }
}
