//
//  ReachabilityMonitor.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 11..
//

import Network
import Combine

class ReachabilityMonitor {

    enum State {
        case undefined
        case reachable
        case unreachable
    }

    var publisher: AnyPublisher<State, Never> {
        networkStatusSubject.eraseToAnyPublisher()
    }
    var isReachable: State {
        networkStatusSubject.value
    }

    private let networkStatusSubject: CurrentValueSubject<State, Never>
    private let networkMonitor: NWPathMonitor = .init()

    init() {
        networkStatusSubject = .init(.init(from: networkMonitor.currentPath.status))
        networkMonitor.start(queue: .main)
        networkMonitor.pathUpdateHandler = { [weak self] nwPath in
            self?.networkStatusSubject.send(.init(from: nwPath.status))
        }
    }

    deinit {
        networkMonitor.cancel()
    }
}

extension ReachabilityMonitor.State {
    init(from networkStatus: NWPath.Status) {
        switch networkStatus {
        case .satisfied:
            self = .reachable
        case .unsatisfied:
            self = .unreachable
        case .requiresConnection:
            self = .undefined
        @unknown default:
            self = .undefined
        }
    }
}
