//
//  Coordinator.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 14..
//

import Resolver
import Combine

class Coordinator {
    static func make<C: Coordinator>(using container: Resolver, assembly: Assembly, initializer: (Resolver) -> C) -> C {
        var coordinator: C!
        container
            .assembled(using: assembly)
            .useContext {
                coordinator = initializer(container)
            }
        #if DEBUG
        coordinator.tag = String(describing: coordinator).lowercased().removing(suffix: "coordinator")
        #endif
        return coordinator
    }

    let container: Resolver
    var childCoordinators: [Coordinator] = []
    var disposeBag = Set<AnyCancellable>()
    #if DEBUG
    var tag = ""
    #endif

    init(container: Resolver) {
        self.container = container
    }

    deinit {
        // This looks unnecessary, but is not
        // This is used for breaking retain cycle between services, injectors and cache
        container.cache.reset()
    }

    func add(child: Coordinator) {
        childCoordinators.append(child)
    }

    func remove(child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}
