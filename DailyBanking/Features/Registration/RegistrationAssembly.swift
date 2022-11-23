//
//  RegistrationAssembly.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 15..
//

import Apollo
import Foundation
import Resolver
import BankAPI

class RegistrationAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext {
            RegistrationWelcomeScreenViewModel()
        }

        container.registerInContext {
            RegistrationStartScreenViewModel()
        }

        container.registerInContext {
            PasswordCreationScreenViewModel()
        }

        container.registerInContext {
            RegistrationOTPScreenViewModel()
        }

        container.registerInContext {
            PinCreationScreenViewModel()
        }

        container.registerInContext {
            DeviceActivationStartScreenViewModel()
        }

        container.registerInContext(RegistrationWelcomeScreen<RegistrationWelcomeScreenViewModel>.self) { container in
            RegistrationWelcomeScreen(viewModel: container.resolve())
        }

        container.registerInContext(RegistrationStartScreen<RegistrationStartScreenViewModel>.self) { container in
            RegistrationStartScreen(viewModel: container.resolve())
        }

        container.registerInContext(PasswordCreationScreen<PasswordCreationScreenViewModel>.self) { container in
            PasswordCreationScreen(viewModel: container.resolve())
        }

        container.registerInContext(RegistrationOTPScreen<RegistrationOTPScreenViewModel>.self) { container in
            RegistrationOTPScreen(viewModel: container.resolve())
        }

        container.registerInContext(PinPadScreen<PinCreationScreenViewModel>.self) { container in
            .init(viewModel: container.resolve())
        }

        container.registerInContext(DeviceActivationStartScreen<DeviceActivationStartScreenViewModel>.self) { container in
            .init(viewModel: container.resolve())
        }

        container.registerInContext {
            RegisterActionImpl()
        }
        .implements(RegisterAction.self)

        container.registerInContext(Mapper<VerifyOtpMutation.Data, Token>.self) {
            VerifyOTPDataMapper()
        }

        container.registerInContext {
            MemoryRegistrationDraftStore()
        }
        .implements((any RegistrationDraftStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<RegistrationDraft>.self) { container in
            let store: any RegistrationDraftStore = container.resolve()
            return store.state
        }
    }
}
