//
//  LoginErrorMapper.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 21..
//

import Apollo
import Foundation

class LoginErrorMapper: Mapper<[GraphQLError], LoginError?> {
    override func map(_ item: [GraphQLError]) throws -> LoginError? {
        if let error = item.first(where: { $0.statusCode == 401 }), error.status == "UNAUTHORIZED",
                  let data: [String: Any] = error.data(),
                  let attempts: Int = data.value(forKey: "remainingAttempts") {
            return .invalidPin(remainingAttempts: attempts)

        } else if let error = item.first(where: { $0.statusCode == 403 }), error.status == "DEVICE_ACTIVATION_REQUIRED" {
            return .deviceActivationRequired

        } else if let error = item.first(where: { $0.statusCode == 423 }), error.status == "TEMPORARY_BLOCKED",
                  let data: [String: Any] = error.data(),
                  let blockedTime: Int = data.value(forKey: "blockedTime") {
            return .temporaryBlocked(blockedTime: blockedTime)
        }

        return nil
    }
}
