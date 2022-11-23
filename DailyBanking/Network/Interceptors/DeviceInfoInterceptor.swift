//
//  DeviceInfoInterceptor.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 21..
//

import Apollo
import Resolver

class DeviceInfoInterceptor: ApolloInterceptor {
    @Injected(container: .root) private var deviceInfo: DeviceInformation

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>
    ) -> Void) {
        request.addHeader(name: "device-name", value: deviceInfo.name)
        request.addHeader(name: "device-type", value: deviceInfo.model)
        request.addHeader(name: "device-platform", value: "IOS")
        chain.proceedAsync(
            request: request,
            response: response,
            completion: completion
        )
    }
}
