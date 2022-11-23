//
//  DebugDelayInterceptor.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 28..
//

import Apollo
import Foundation
import Resolver

class DebugDelayInterceptor: ApolloInterceptor {

    @Injected(container: .root) private var appConfig: AppConfig

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>
    ) -> Void) {
        let proceed = {
            chain.proceedAsync(
                request: request,
                response: response,
                completion: completion
            )
        }

        let delay = appConfig.general.communicationDelay
        if delay == 0 {
            proceed()
        } else if Thread.current.isMainThread {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                proceed()
            }
        } else {
            Thread.sleep(forTimeInterval: delay)
            proceed()
        }
    }
}
