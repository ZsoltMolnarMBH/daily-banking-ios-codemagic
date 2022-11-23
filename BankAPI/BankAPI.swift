//
//  BankAPI.swift
//  BankAPI
//
//  Created by Molnár Zsolt on 2021. 10. 14..
//

import Apollo
import Combine
import Foundation

public class BankAPI {

    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    public static let dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    public static let dateFormatters = [dateFormatter, dateFormatter2]

    public enum Error: Swift.Error {
        case noData
        case graphQLError(errors: [GraphQLError])
    }

    private let apollo: ApolloClientProtocol

    public init(apollo: ApolloClientProtocol) {
        self.apollo = apollo
    }

    public func publisher<Query: GraphQLQuery>(
        for query: Query,
        cachePolicy: CachePolicy
    ) -> AnyPublisher<Query.Data, Swift.Error> {
        let config = Publishers.ApolloFetchConfiguration(
            client: apollo,
            query: query,
            cachePolicy: cachePolicy,
            contextIdentifier: nil,
            queue: .main
        )
        return Publishers.ApolloFetch(with: config)
            .tryMap()
            .eraseToAnyPublisher()
    }

    public func publisher<Mutation: GraphQLMutation>(
        for mutation: Mutation
    ) -> AnyPublisher<Mutation.Data, Swift.Error> {
        let config = Publishers.ApolloPerformConfiguration(
            client: apollo,
            mutation: mutation,
            publishResultToStore: true,
            queue: .main
        )
        return Publishers.ApolloPerform(with: config)
            .tryMap()
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func tryMap<T>() -> Publishers.TryMap<Self, T> where Output == GraphQLResult<T> {
        tryMap { output in
            if let errors = output.errors {
                throw BankAPI.Error.graphQLError(errors: errors)
            } else if let data = output.data {
                return data
            } else {
                throw BankAPI.Error.noData
            }
        }
    }
}
