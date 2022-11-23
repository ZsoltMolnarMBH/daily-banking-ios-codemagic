//
//  PinVerificationErrorMapper.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 21..
//

import Apollo
import Foundation

class PinVerificationErrorMapper: Mapper<[GraphQLError]?, PinVerificationError?> {
    override func map(_ item: [GraphQLError]?) throws -> PinVerificationError? {
        if let error = item?.first(where: { $0.statusCode == 400 }), error.status == "EMPTY_OTP",
           let data: [String: Any] = error.data(),
           let attempts: Int = data.value(forKey: "remainingAttempts") {
            return .invalidPin(remainingAttempts: attempts)

        } else if let error = item?.first(where: { $0.statusCode == 403 }), error.status == "WRONG_OTP",
                  let data: [String: Any] = error.data(),
                  let attempts: Int = data.value(forKey: "remainingAttempts") {
            return .invalidPin(remainingAttempts: attempts)

        } else if let error = item?.first(where: { $0.statusCode == 423 }), error.status == "FORCE_LOGOUT" {
            return .forceLogout
        }

        return nil
    }
}
