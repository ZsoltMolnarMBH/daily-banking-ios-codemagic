//
//  RefreshTokenAction.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 04..
//

import BankAPI
import Combine
import Resolver

protocol RefreshTokenAction {
    func refreshTokens() -> AnyPublisher<Never, AnyActionError>
}

class RefreshTokenActionImpl: RefreshTokenAction {

    @Injected(container: .root) private var tokenStore: any TokenStore
    @Injected(container: .root) private var tokenMapper: Mapper<TokenFragment, Token>
    @Injected(container: .root) private var api: APIProtocol

    private let queue = DispatchQueue(label: "refreshTokenQueue")
    private var refreshingTokens: AnyPublisher<Never, AnyActionError>?

    func refreshTokens() -> AnyPublisher<Never, AnyActionError> {
        var refresh: AnyPublisher<Never, AnyActionError>!
        queue.sync {
            if let refreshingTokens = refreshingTokens {
                refresh = refreshingTokens
            } else {
                let subscription = api.publisher(for: RefreshTokensQuery(), cachePolicy: .fetchIgnoringCacheCompletely)
                    .tryMap { [tokenMapper] response in
                        try tokenMapper.map(response.getTokens.fragments.tokenFragment)
                    }
                    .map({ [tokenStore] token in
                        tokenStore.modify {
                            $0 = token
                        }
                    })
                    .handleEvents(receiveCompletion: { [weak self, tokenStore] completion in
                        self?.refreshingTokens = nil
                        switch completion {
                        case .failure(let error) where error.graphQLError(statusCode: 401) != nil:
                            tokenStore.modify {
                                $0 = nil
                            }
                        default:
                            break
                        }
                    }, receiveCancel: { [weak self] in
                        self?.refreshingTokens = nil
                    })
                    .ignoreOutput()
                    .receive(on: DispatchQueue.main)
                    .share()
                    .eraseToAnyPublisher()

                refreshingTokens = subscription.mapAnyActionError()
                refresh = subscription.mapAnyActionError()
            }
        }
        return refresh
    }
}
