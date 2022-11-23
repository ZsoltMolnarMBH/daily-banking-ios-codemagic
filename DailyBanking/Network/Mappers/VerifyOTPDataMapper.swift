//
//  VerifyOTPDataMapper.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 04..
//

import Foundation
import BankAPI

class VerifyOTPDataMapper: Mapper<VerifyOtpMutation.Data, Token> {
    override func map(_ item: VerifyOtpMutation.Data) throws -> Token {
        Token(
            accessToken: item.verifyOtp.accessToken,
            refreshToken: item.verifyOtp.refreshToken
        )
    }
}
