//
//  RefreshTokenInterceptor.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 04..
//

import Apollo
import Foundation
import Resolver

class RefreshTokenInterceptor: ApolloInterceptor {

    @Injected(container: .root) private var token: ReadOnly<Token?>

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>
    ) -> Void) {
        if let token = token.value {
            request.addHeader(name: "Authorization", value: "Bearer \(token.refreshToken)")
        }
        chain.proceedAsync(
            request: request,
            response: response,
            completion: completion
        )
    }
}
