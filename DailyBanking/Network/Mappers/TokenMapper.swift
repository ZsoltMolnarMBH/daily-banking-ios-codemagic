//
//  TokenMapper.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 15..
//

import Foundation
import BankAPI

class TokenMapper: Mapper<TokenFragment, Token> {
    override func map(_ item: TokenFragment) throws -> Token {
        Token(
            accessToken: item.accessToken,
            refreshToken: item.refreshToken
        )
    }
}
