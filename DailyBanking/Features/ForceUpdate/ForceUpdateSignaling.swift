//
//  ForceUpdateSignaling.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 25..
//

import Combine
import Foundation

protocol ForceUpdateSignalReceiver {
    var publisher: AnyPublisher<ForceUpdateSignal, Never> { get }
}

protocol ForceUpdateSignalBroadcaster {
    func send(signal kind: ForceUpdateSignal)
}

enum ForceUpdateSignal {
    case warning, block
}

class ForceUpdateSignaling: ForceUpdateSignalReceiver, ForceUpdateSignalBroadcaster {
    var publisher: AnyPublisher<ForceUpdateSignal, Never> {
        _publisher.eraseToAnyPublisher()
    }
    private let _publisher = PassthroughSubject<ForceUpdateSignal, Never>()

    func send(signal kind: ForceUpdateSignal) {
        _publisher.send(kind)
    }
}
