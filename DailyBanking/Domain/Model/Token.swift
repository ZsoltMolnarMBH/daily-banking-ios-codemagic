//
//  Token.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 15..
//

import Foundation

struct Token: Equatable {
    let foregroundSessionExpired: Bool
    let accessToken: String
    let refreshToken: String

    init(foregroundSessionExpired: Bool = false, accessToken: String, refreshToken: String) {
        self.foregroundSessionExpired = foregroundSessionExpired
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    var expired: Token {
        .init(foregroundSessionExpired: true, accessToken: accessToken, refreshToken: refreshToken)
    }
}
