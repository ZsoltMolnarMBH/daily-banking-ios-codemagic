//
//  EnvironmentConfig.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 04. 08..
//

import Confy

class EnvironmentConfig: ConfigGroup {
    var currentEnvironment: RemoteEnvironment {
        environments.first { $0.name == current }!
    }

    @Config({
        #if DEBUG
        .vpnDev
        #else
        .chaosTest
        #endif
    }) var current: RemoteEnvironment.Name

    @Config({
        [
            RemoteEnvironment(
                name: .vpnDev,
                graphQLEndpoint: URL(string: "https://graphql.dev-foundation.com")!
            ),
            RemoteEnvironment(
                name: .development,
                graphQLEndpoint: URL(string: "https://graphql.dev.sandbox-mbh.net/graphql")!
            ),
            RemoteEnvironment(
                name: .chaosTest,
                graphQLEndpoint: URL(string: "https://graphql-test.dev.sandbox-mbh.net/graphql")!
            )
        ]
    }) var environments: [RemoteEnvironment]
}
