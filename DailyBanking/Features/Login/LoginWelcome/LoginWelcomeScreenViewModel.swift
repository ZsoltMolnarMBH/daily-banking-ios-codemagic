//
//  LoginWelcomeScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 26..
//

import Combine
import Resolver

enum LoginWelcomeScreenEvent {
    case startLogin
}

class LoginWelcomeScreenViewModel: ScreenViewModel<LoginWelcomeScreenEvent>, LoginWelcomeScreenViewModelProtocol {

    @Injected private var user: ReadOnly<User?>

    @Published var initials: String = ""
    @Published var welcomeMessage: String = ""
    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        initials = user.value?.name.initials ?? ""
        let userName = user.value?.name.firstName ?? ""
        switch Date().timeOfDay {
        case .morning:
            welcomeMessage = Strings.Localizable.loginGreetingMorning(userName)
        case .afternoon:
            welcomeMessage = Strings.Localizable.loginGreetingAfternoon(userName)
        case .night:
            welcomeMessage = Strings.Localizable.loginGreetingNight(userName)
        }
    }

    func handle(_ event: LoginWelcomeScreenInput) {
        switch event {
        case .login:
            events.send(.startLogin)
        }
    }
}
