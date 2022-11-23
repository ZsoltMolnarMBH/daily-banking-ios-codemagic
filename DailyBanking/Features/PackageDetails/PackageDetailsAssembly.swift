//
//  PackageDetailsAssembly.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 30..
//

import Foundation
import Resolver

class PackageDetailsAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext {
            PackageDetailsScreenViewModel()
        }

        container.registerInContext(PackageDetailsScreen<PackageDetailsScreenViewModel>.self) { container in
            PackageDetailsScreen(viewModel: container.resolve())
        }
    }
}
