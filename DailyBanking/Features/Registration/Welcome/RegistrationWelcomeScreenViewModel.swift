//
//  RegistrationWelcomeScreenViewModel.swift
//  app-daily-banking-ios
//
//  Created by Zsombor Szabó on 2021. 10. 05..
//

import BankAPI
import Combine
import Resolver
import LocalAuthentication

enum RegistrationWelcomeScreenEvent {
    case startRegistration
    case startDeviceActivation
}

class RegistrationWelcomeScreenViewModel: ScreenViewModel<RegistrationWelcomeScreenEvent>,
                                          RegistrationWelcomeScreenViewModelProtocol {
    let greetingsText: String = {
        switch Date().timeOfDay {
        case .morning:
            return Strings.Localizable.startGreetingMorning
        case .afternoon:
            return Strings.Localizable.startGreetingAfternoon
        case .night:
            return Strings.Localizable.startGreetingNight
        }
    }()

    func handle(event: RegistrationWelcomeScreenInput) {
        switch event {
        case .registration:
            events.send(.startRegistration)
        case .login:
            events.send(.startDeviceActivation)
        }
    }
}
