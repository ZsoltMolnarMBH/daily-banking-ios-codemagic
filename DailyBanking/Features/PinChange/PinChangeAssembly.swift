//
//  PinChangeAssembly.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 16..
//

import Resolver

class PinChangeAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext {
            PinChangeViewModel()
        }

        container.registerInContext(PinPadScreen<PinChangeViewModel>.self) { container in
            .init(viewModel: container.resolve())
        }
    }
}
