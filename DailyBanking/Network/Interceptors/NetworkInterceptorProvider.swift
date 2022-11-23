//
//  NetworkInterceptorProvider.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 15..
//

import Foundation
import Apollo
import BankAPI

struct NetworkInterceptorProvider: InterceptorProvider {

    private let store: ApolloStore
    private let client: URLSessionClient

    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }

    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        let tokenInterceptor: ApolloInterceptor
        if operation is RefreshTokensQuery {
            tokenInterceptor = RefreshTokenInterceptor()
        } else {
            tokenInterceptor = AccessTokenInterceptor()
        }

        var interceptors = [ApolloInterceptor]()
        if protectedEndpoints.contains(where: { type(of: operation) == $0 }) {
            interceptors.append(SecondLevelAuthInterceptor())
        }

        interceptors.append(contentsOf: [
            ForceUpdateInterceptor(),
            DeviceInfoInterceptor(),
            tokenInterceptor,
            RequestLoggingInterceptor()
        ])

        #if DEBUG
        interceptors.append(DebugDelayInterceptor())
        #endif

        interceptors.append(contentsOf: [
            NetworkFetchInterceptor(client: client),
            ResponseLoggingInterceptor(),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(cacheKeyForObject: store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor()
        ] as [ApolloInterceptor])

        return interceptors
    }

    private var protectedEndpoints: [AnyClass] = [
        InitiateNewTransferV2Mutation.self,
        SetLimitMutation.self,
        ProxyIdDeleteMutation.self,
        CardDetailsQuery.self,
        CardPinQuery.self,
        SetCardStatusMutation.self,
        ChangeCardLimitMutation.self,
        ReorderCardMutation.self,
        ApproveScaChallengeMutation.self
    ]
}
