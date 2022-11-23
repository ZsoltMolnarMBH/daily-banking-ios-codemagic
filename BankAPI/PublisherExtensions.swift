//
//  PublisherExtensions.swift
//  BankAPI
//
//  Created by Szabó Zoltán on 2022. 02. 16..
//

import Apollo
import Foundation
import Combine

extension Publishers {
    struct ApolloFetch<Query: GraphQLQuery>: Publisher {
        public typealias Output = GraphQLResult<Query.Data>
        public typealias Failure = Error

        private let configuration: ApolloFetchConfiguration<Query>

        public init(with configuration: ApolloFetchConfiguration<Query>) {
            self.configuration = configuration
        }

        public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            let subscription = ApolloFetchSubscription(subscriber: subscriber, configuration: configuration)
            subscriber.receive(subscription: subscription)
        }
    }

    struct ApolloFetchConfiguration<Query: GraphQLQuery> {
        let client: ApolloClientProtocol
        let query: Query
        let cachePolicy: CachePolicy
        let contextIdentifier: UUID?
        let queue: DispatchQueue
    }

    private final class ApolloFetchSubscription<S: Subscriber, Query: GraphQLQuery>: Subscription
    where S.Failure == Error, S.Input == GraphQLResult<Query.Data> {
        private let configuration: ApolloFetchConfiguration<Query>
        var subscriber: S?
        private var task: Apollo.Cancellable?

        init(subscriber: S?, configuration: ApolloFetchConfiguration<Query>) {
            self.subscriber = subscriber
            self.configuration = configuration
        }

        func request(_ demand: Subscribers.Demand) {
            guard task == nil && demand > .none else { return }
            task = configuration.client.fetch(
                query: configuration.query,
                cachePolicy: configuration.cachePolicy,
                contextIdentifier: configuration.contextIdentifier,
                queue: configuration.queue) { [weak self] result in
                    switch result {
                    case .success(let data):
                        _ = self?.subscriber?.receive(data)

                        if self?.configuration.cachePolicy == .returnCacheDataAndFetch && data.source == .cache {
                            return
                        }
                        self?.subscriber?.receive(completion: .finished)

                    case .failure(let error):
                        self?.subscriber?.receive(completion: .failure(error))
                    }
                }
        }

        func cancel() {
            task?.cancel()
            task = nil
            subscriber = nil
        }
    }

    // MARK: - Perform
    struct ApolloPerform<Mutation: GraphQLMutation>: Publisher {
        public typealias Output = GraphQLResult<Mutation.Data>
        public typealias Failure = Error

        private let configuration: ApolloPerformConfiguration<Mutation>

        public init(with configuration: ApolloPerformConfiguration<Mutation>) {
            self.configuration = configuration
        }

        public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            let subscription = ApolloPerformSubscription(subscriber: subscriber, configuration: configuration)
            subscriber.receive(subscription: subscription)
        }
    }

    struct ApolloPerformConfiguration<Mutation: GraphQLMutation> {
        let client: ApolloClientProtocol
        let mutation: Mutation
        let publishResultToStore: Bool
        let queue: DispatchQueue
    }

    private final class ApolloPerformSubscription<S: Subscriber, Mutation: GraphQLMutation>: Subscription
    where S.Failure == Error, S.Input == GraphQLResult<Mutation.Data> {
        private let configuration: ApolloPerformConfiguration<Mutation>
        private var subscriber: S?
        private var task: Apollo.Cancellable?

        init(subscriber: S, configuration: ApolloPerformConfiguration<Mutation>) {
            self.subscriber = subscriber
            self.configuration = configuration
        }

        func request(_ demand: Subscribers.Demand) {
            guard task == nil && demand > .none else { return }
            task = configuration.client.perform(
                mutation: configuration.mutation,
                publishResultToStore: configuration.publishResultToStore,
                queue: configuration.queue) { [weak self] result in
                    switch result {
                    case .success(let data):
                        _ = self?.subscriber?.receive(data)
                        self?.subscriber?.receive(completion: .finished)

                    case .failure(let error):
                        self?.subscriber?.receive(completion: .failure(error))
                    }
                }
        }

        func cancel() {
            task?.cancel()
            task = nil
            subscriber = nil
        }
    }
}
