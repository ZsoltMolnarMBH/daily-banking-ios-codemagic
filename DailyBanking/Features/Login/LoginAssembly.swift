//
//  LoginAssembly.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 26..
//

import Apollo
import BankAPI
import Resolver

class LoginAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext {
            LoginActionImpl()
        }
        .implements(LoginAction.self)

        container.registerInContext(Mapper<[GraphQLError], LoginError?>.self) {
            LoginErrorMapper()
        }

        container.registerInContext {
            LoginWelcomeScreenViewModel()
        }

        container.registerInContext {
            LoginEnterPinScreenViewModel()
        }

        container.registerInContext(LoginWelcomeScreen<LoginWelcomeScreenViewModel>.self) { container in
            LoginWelcomeScreen(viewModel: container.resolve())
        }

        container.registerInContext(PinPadScreen<LoginEnterPinScreenViewModel>.self) { container in
            PinPadScreen<LoginEnterPinScreenViewModel>(viewModel: container.resolve())
        }
    }
}
