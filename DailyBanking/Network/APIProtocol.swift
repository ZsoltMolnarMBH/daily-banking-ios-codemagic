//
//  APIProtocol.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 11. 16..
//

import Foundation
import Apollo
import BankAPI
import Combine

protocol APIProtocol: AutoMockable {
    func publisher<Query: GraphQLQuery>(
        for query: Query,
        cachePolicy: CachePolicy
    ) -> AnyPublisher<Query.Data, Swift.Error>

    func publisher<Mutation: GraphQLMutation>(
        for mutation: Mutation
    ) -> AnyPublisher<Mutation.Data, Swift.Error>
}

extension BankAPI: APIProtocol {}
