//
//  DashboardAssembly.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 12..
//

import Resolver
import BankAPI

class DashboardAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext { container in
            container.resolve(AppConfig.self).dashboard
        }
        .implements(DashboardConfig.self)

        container.registerInContext {
            DashboardScreenViewModel()
        }

        container.registerInContext(DashboardScreen.self) { container in
            DashboardScreenComposite(viewModel: container.resolve(), proxyId: container.resolve(), scaChallengeVM: container.resolve())
        }

        container.registerInContext {
            AccountDetailsScreenViewModel()
        }

        container.registerInContext(AccountDetailsScreen.self) { container in
            AccountDetailsScreen(viewModel: container.resolve(), proxyId: container.resolve())
        }

        container.registerInContext {
            ProfileScreenViewModel()
        }

        container.registerInContext(ProfileScreen<ProfileScreenViewModel>.self) { container in
            ProfileScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            PersonalInfoScreenViewModel()
        }

        container.registerInContext(PersonalInfoScreen<PersonalInfoScreenViewModel>.self) { container in
            PersonalInfoScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            UserContractsScreenViewModel()
        }

        container.registerInContext(UserContractsScreen<UserContractsScreenViewModel>.self) { container in
            UserContractsScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            MonthlyStatementsScreenViewModel()
        }

        container.registerInContext(MonthlyStatementsScreen<MonthlyStatementsScreenViewModel>.self) { container in
            MonthlyStatementsScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            AccountLimitStartPageScreenViewModel()
        }

        container.registerInContext(AccountLimitStartPageScreen<AccountLimitStartPageScreenViewModel>.self) { container in
            AccountLimitStartPageScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            AccountDailyTransferLimitScreenViewModel()
        }

        container.registerInContext(AccountDailyTransferLimitScreen<AccountDailyTransferLimitScreenViewModel>.self) { container in
            AccountDailyTransferLimitScreen(viewModel: container.resolve())
        }
    }
}
