//
//  AccessTokenInterceptor.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 15..
//

import Apollo
import Combine
import Resolver

class AccessTokenInterceptor: ApolloInterceptor {

    @Injected(container: .root) private var token: ReadOnly<Token?>
    @Injected(container: .root) private var action: RefreshTokenAction
    private var disposeBag = Set<AnyCancellable>()
    private var isFirst = true

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>
    ) -> Void) {
        if let token = token.value, !token.foregroundSessionExpired {
            request.addHeader(name: "Authorization", value: "Bearer \(token.accessToken)")
        }
        chain.proceedAsync(
            request: request,
            response: response,
            completion: { [weak self] result in
                switch result {
                case .success(let result):
                    if let error = result.errors?.first(where: { $0.statusCode == 401 }),
                        error.status == "TOKEN_EXPIRED" {
                        guard let self = self else { return }
                        self.action
                            .refreshTokens()
                            .sink(receiveCompletion: { event in
                                switch event {
                                case .finished:
                                    chain.retry(
                                        request: request,
                                        completion: completion
                                    )
                                case .failure:
                                    completion(.failure(error))
                                }
                            })
                            .store(in: &self.disposeBag)
                    } else {
                        completion(.success(result))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
}
