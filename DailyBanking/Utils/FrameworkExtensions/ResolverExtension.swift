//
//  ResolverExtension.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 14..
//

import Resolver

// MARK: Assembly

public protocol Assembly {
    func assemble(container: Resolver)
}

@propertyWrapper struct Assembled {
    private let assembly: Assembly
    var wrappedValue: Resolver? {
        didSet {
            wrappedValue?.assembled(using: assembly)
        }
    }

    init(wrappedValue: Resolver? = nil, by assembly: Assembly) {
        self.assembly = assembly
        wrappedValue?.assembled(using: assembly)
        self.wrappedValue = wrappedValue
    }
}

public extension Resolver {
    @discardableResult
    func assembled(using assembly: Assembly) -> Self {
        assembly.assemble(container: self)
        return self
    }
}

// MARK: Classic hierachy

public extension Resolver {
    func makeChild() -> Resolver {
        // Resolver v1.5 has reversed the meaning of child containers.
        // Formerly the `child` argument was called `parent`.
        return Resolver(child: self)
    }
}

// MARK: Dynamic container extensions

public extension Resolver {
    fileprivate static var currentContext: Resolver?

    /// Contextual container, to be used by dependencies of a resolved service.
    /// Has value during resolution cycle, if specified using the `.context` registraion operator..
    static var context: Resolver {
        guard let container = currentContext else {
            fatalError("RESOLVER: Context not set!.")
        }
        return container
    }

    static func useContext(container: Resolver, block: () -> Void) {
        if currentContext != nil {
            fatalError("RESOLVER: Context is already set!")
        }
        currentContext = container
        block()
        currentContext = nil
    }

    func useContext(_ block: () -> Void) {
        Self.useContext(container: self, block: block)
    }

    @discardableResult
    final func registerInContext<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil,
                                          factory: @escaping ResolverFactory<Service>) -> ResolverOptions<Service> {
        return register(type, name: name, factory: factory).context(self)
    }

    @discardableResult
    final func registerInContext<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil,
                                          factory: @escaping ResolverFactoryResolver<Service>) -> ResolverOptions<Service> {
        return register(type, name: name, factory: factory).context(self)
    }

    @discardableResult
    final func registerInContext<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil,
                                          factory: @escaping ResolverFactoryArgumentsN<Service>) -> ResolverOptions<Service> {
        return register(type, name: name, factory: factory).context(self)
    }
}

public extension ResolverOptions {
    /// Sets given container to be `Resolver.context`, for the time of resolution,
    /// so dependencies of the service can be resolved from it.
    /// - Parameter container: container to be set as `Resolver.context`
    @discardableResult
    func context(_ container: Resolver) -> ResolverOptions<Service> {
        registration.update { existingFactory in
            return { [weak container] (resolver, args) in
                if let container = container, Resolver.currentContext == nil {
                    var result: Service?
                    container.useContext {
                        result = existingFactory(resolver, args)
                    }
                    return result
                } else {
                    return existingFactory(resolver, args)
                }
            }
        }
        return self
    }
}

public extension Injected {
    init() {
        self.init(container: .context)
    }

    init(name: Resolver.Name? = nil) {
        self.init(name: name, container: .context)
    }
}

public extension LazyInjected {
    init() {
        self.init(container: .context)
    }

    init(name: Resolver.Name? = nil) {
        self.init(name: name, container: .context)
    }
}

public extension OptionalInjected {
    init() {
        self.init(container: .context)
    }

    init(name: Resolver.Name? = nil) {
        self.init(name: name, container: .context)
    }
}

public extension WeakLazyInjected {
    init() {
        self.init(container: .context)
    }

    init(name: Resolver.Name? = nil) {
        self.init(name: name, container: .context)
    }
}
