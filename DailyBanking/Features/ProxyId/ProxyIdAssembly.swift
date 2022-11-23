//
//  ProxyIdAssembly.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 11..
//

import Resolver

class ProxyIdAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext {
            MemoryProxyIdDraftStore()
        }
        .implements((any ProxyIdDraftStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<ProxyIdDraft>.self) { container in
            let store: any ProxyIdDraftStore = container.resolve()
            return store.state
        }

        container.registerInContext {
            ProxyIdConfirmationScreenViewModel()
        }

        container.registerInContext(ProxyIdConfirmationScreen<ProxyIdConfirmationScreenViewModel>.self) { container in
            ProxyIdConfirmationScreen(viewModel: container.resolve())
        }
    }
}
