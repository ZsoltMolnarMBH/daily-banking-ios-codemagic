//
//  SecondLevelAuthInterceptor.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 04..
//

import Apollo
import Combine
import Foundation
import Resolver

class SecondLevelAuthInterceptor: ApolloInterceptor {

    @Injected(container: .root) private var errorMapper: Mapper<[GraphQLError]?, PinVerificationError?>
    @Injected(container: .root) private var auth: SecondLevelAuthentication
    @Injected(container: .root) private var tokenStore: any TokenStore

    private var disposeBag = Set<AnyCancellable>()
    private var isFirstInterception: Bool = true

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
        if isFirstInterception {
            setup(
                chain: chain,
                request: request,
                response: response,
                completion: completion
            )
        } else {
            chain.proceedAsync(
                request: request,
                response: response,
                completion: { [weak self] result in
                    self?.handle(result, completion: completion)
                }
            )
        }
    }

    private func setup<T: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<T>,
        response: HTTPResponse<T>?,
        completion: @escaping (Result<GraphQLResult<T.Data>, Error>) -> Void
    ) {
        auth.display?
            .publisher
            .sink(receiveValue: { [weak self, weak chain] event in
                switch event {
                case .cancel:
                    chain?.cancel()
                    completion(.failure(SecondLevelAuthError.cancelled))

                case .otpCreated(let otp):
                    request.addHeader(name: "otp", value: otp)
                    if self?.isFirstInterception == true {
                        self?.isFirstInterception = false
                        chain?.proceedAsync(
                            request: request,
                            response: response,
                            completion: { [weak self] result in
                                self?.handle(result, completion: completion)
                            }
                        )
                    } else {
                        chain?.retry(
                            request: request,
                            completion: { [weak self] result in
                                self?.handle(result, completion: completion)
                        })
                    }
                }
            })
            .store(in: &self.disposeBag)
    }

    private func handle<T>(_ result: Result<GraphQLResult<T>, Error>, completion: @escaping (Result<GraphQLResult<T>, Error>) -> Void) {
        switch result {
        case .success(let result):
            if let error = try? errorMapper.map(result.errors) {
                auth.display?.eventHandler.send(.failure(error))
            } else {
                auth.display?.eventHandler.send(.success(()))
                completion(.success(result))
            }
        case .failure(let error):
            /*
             Any other error (e.g. no internet).
             Currently we're sending a success event to the display to close the pin screen.
             The error will be propageted to the caller side
             */
            auth.display?.eventHandler.send(.success(()))
            completion(.failure(error))
        }
    }
}
