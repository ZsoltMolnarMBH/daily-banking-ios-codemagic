//
//  CombineTestingHelpers.swift
//  DailyBankingTests
//
//  Created by Zsolt Molnár on 2022. 03. 21..
//

import Combine
import Apollo
import BankAPI
@testable import DailyBanking

extension Publisher {
    static func just<T>(_ value: T) -> AnyPublisher<T, Error> {
        Just(value)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    static func error<T>(_ error: Error) -> AnyPublisher<T, Error> {
        Fail<T, Error>(outputType: T.self,
                       failure: error)
            .eraseToAnyPublisher()
    }

    static func error<T>(graphQL: GraphQLError) -> AnyPublisher<T, Error> {
        Fail<T, Error>(outputType: T.self,
                       failure: BankAPI.Error.graphQLError(errors: [graphQL]))
            .eraseToAnyPublisher()
    }

    static func error<T>(communication: CommunicationError) -> AnyPublisher<T, Error> {
        Fail<T, Error>(outputType: T.self, failure: communication)
            .eraseToAnyPublisher()
    }

    func collectOutput(_ store: inout Set<AnyCancellable>) -> OutputCollection<Output> {
        let collection = OutputCollection<Output>()
        self.sink { _ in
            //
        } receiveValue: { [collection] output in
            collection.items.append(output)
        }.store(in: &store)
        return collection
    }
}

class OutputCollection<T> {
    var items = [T]()

    func verify(_ blocks: ((T) -> Void)...) {
        blocks.enumerated().forEach { (index, block) in
            block(items[index])
        }
    }
}
