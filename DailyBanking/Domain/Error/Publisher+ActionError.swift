//
//  Publisher+ActionError.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 05. 02..
//

import Foundation
import Combine

extension Publisher {
    func mapActionError<E>(to failureType: E.Type) -> AnyPublisher<Self.Output, ActionError<E>> where E: Error {
        return self.mapError { error -> ActionError<E> in
            let mappedError: ActionError<E>
            if let networkError = error as? CommunicationError {
                mappedError = .network(networkError)
            } else if let authError = error as? SecondLevelAuthError {
                mappedError = .secondLevelAuth(authError)
            } else if let specificError = error as? E {
                mappedError = .action(specificError)
            } else {
                mappedError = .unknown(error)
            }
            return mappedError
        }
        .eraseToAnyPublisher()
    }

    func mapAnyActionError() -> AnyPublisher<Self.Output, AnyActionError> {
        return self.mapError { error -> AnyActionError in
            let mappedError: AnyActionError
            if let networkError = error as? CommunicationError {
                mappedError = .network(networkError)
            } else if let authError = error as? SecondLevelAuthError {
                mappedError = .secondLevelAuth(authError)
            } else {
                mappedError = .unknown(error)
            }
            return mappedError
        }
        .eraseToAnyPublisher()
    }
}
