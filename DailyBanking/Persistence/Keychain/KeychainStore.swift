//
//  KeychainStore.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 09. 15..
//

import Foundation
import Combine
import KeychainAccess
import Resolver

class KeychainStore<State: Codable> {
    @Injected private var keychain: Keychain
    private let stateSubject = PassthroughSubject<State?, Never>()
    private let key: String
    private var lock = NSRecursiveLock()

    init(key: String) {
        self.key = key
    }

    var state: ReadOnly<State?> {
        .init(value: read(), publisher: stateSubject.eraseToAnyPublisher())
    }

    func modify(_ transform: @escaping (inout State?) -> Void) {
        lock.lock(); defer { lock.unlock() }
        var copy = read()
        transform(&copy)
        save(copy)
        stateSubject.send(copy)
    }

    private func read() -> State? {
        if let data = try? keychain.getData(key) {
            return try? JSONDecoder().decode(State.self, from: data)
        } else {
            return nil
        }
    }

    private func save(_ newState: State?) {
        guard let newState = newState,
            let encoded = try? JSONEncoder().encode(newState) else {
            try? keychain.remove(key)
            return
        }
        try? keychain.set(encoded, key: key)
    }
}
