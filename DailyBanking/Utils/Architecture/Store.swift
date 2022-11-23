//
//  Store.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 14..
//

import Foundation
import Combine

protocol Store: AnyObject {
    associatedtype State
    var state: ReadOnly<State> { get }
    func modify(_ transform: @escaping (inout State) -> Void)
}

class MemoryStore<State> {
    private var stateSubject: CurrentValueSubject<State, Never>
    private var lock: NSRecursiveLock = NSRecursiveLock()

    init(state: State) {
        stateSubject = CurrentValueSubject<State, Never>(state)
    }
}

extension MemoryStore: Store {
    var state: ReadOnly<State> {
        ReadOnly<State>(stateSubject: stateSubject)
    }

    func modify(_ transform: @escaping (inout State) -> Void) {
        lock.lock(); defer { lock.unlock() }
        var copy = stateSubject.value
        transform(&copy)
        stateSubject.send(copy)
    }
}
