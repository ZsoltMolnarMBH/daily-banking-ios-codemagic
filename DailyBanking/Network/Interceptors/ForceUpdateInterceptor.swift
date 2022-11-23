//
//  ForceUpdateInterceptor.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 25..
//

import Apollo
import Resolver
import Foundation

class ForceUpdateInterceptor: ApolloInterceptor {
    @Injected(container: .root) private var appInfo: AppInformation
    @Injected(container: .root) private var tokenStore: any TokenStore
    @Injected(container: .root) private var broadcaster: ForceUpdateSignalBroadcaster

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>
    ) -> Void) {
        request.addHeader(name: "app-version", value: appInfo.version)
        request.addHeader(name: "app-build", value: appInfo.buildNumber)
        chain.proceedAsync(
            request: request,
            response: response,
            completion: { [broadcaster, tokenStore] result in
                switch result {
                case .success(let result):
                    if let error = result.errors?.first(where: { $0.statusCode == 412 }), error.status == "PRECONDITION_FAILED" {
                        broadcaster.send(signal: .block)
                        tokenStore.modify { $0 = nil }
                    }
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
}
