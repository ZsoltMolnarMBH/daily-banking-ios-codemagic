//
//  RequestLoggingInterceptor.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 15..
//

import Apollo

class RequestLoggingInterceptor: ApolloInterceptor {

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {

        print("Outgoing request?")
        print("\(request)")
        if let data = try? request.toURLRequest().httpBody,
            let body = String(bytes: data, encoding: .utf8)?.removingPercentEncoding {
            print(body.replacingOccurrences(of: "\\n", with: "\n"))
        }

        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
}
