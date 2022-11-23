//
//  BiometrySetupAssembly.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 10..
//

import Foundation
import Resolver

class BiometrySetupAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext {
            BiometrySetupScreenViewModel()
        }

        container.registerInContext(BiometrySetupScreen<BiometrySetupScreenViewModel>.self) { container in
            BiometrySetupScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            BiometryMultiUsageInfoScreenViewModel()
        }

        container.registerInContext {
            BiometryUnavailableScreenViewModel()
        }

        container.registerInContext(BiometryMultiUsageInfoScreen<BiometryMultiUsageInfoScreenViewModel>.self) { container in
            BiometryMultiUsageInfoScreen<BiometryMultiUsageInfoScreenViewModel>(viewModel: container.resolve())
        }

        container.registerInContext(BiometryUnavailableScreen<BiometryUnavailableScreenViewModel>.self) { container in
            BiometryUnavailableScreen<BiometryUnavailableScreenViewModel>(viewModel: container.resolve())
        }
    }
}
