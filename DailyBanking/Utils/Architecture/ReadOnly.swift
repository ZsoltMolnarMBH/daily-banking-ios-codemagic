//
//  ReadOnly.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 03..
//

import Combine
import Foundation

struct ReadOnly<State> {
    private let stateSubject: CurrentValueSubject<State, Never>
    private var disposeBag = Set<AnyCancellable>()
    var publisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    var value: State {
        stateSubject.value
    }

    init(stateSubject: CurrentValueSubject<State, Never>) {
        self.stateSubject = stateSubject
    }
}

extension ReadOnly {
    init(value: State, publisher: AnyPublisher<State, Never>) {
        self.init(stateSubject: CurrentValueSubject(value))
        publisher
            .sink(receiveValue: { [stateSubject] value in
                stateSubject.send(value)
            })
            .store(in: &disposeBag)
    }
}
