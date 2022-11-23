//
//  Error+Extensions.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 04..
//

import BankAPI
import Apollo
import Foundation

typealias CommunicationError = URLSessionClient.URLSessionClientError

/*
 400: ‘VALIDATION_ERROR’,
 401: ‘TOKEN_EXPIRED’,
 403: ‘FORBIDDEN’,
 404: ‘NOT_FOUND’,
 409: ‘CONFLICT’,
 429: ‘TOO_MANY_REQUEST’,
 500: ‘INTERNAL_SERVER_ERROR’,
 */

extension Swift.Error {
    func graphQLError(statusCode: Int) -> GraphQLError? {
        if let error = self as? BankAPI.Error {
            switch error {
            case .noData:
                break
            case .graphQLError(errors: let errors):
                return errors.first(where: { $0.statusCode == statusCode })
            }
        }
        return nil
    }
}

extension GraphQLError {
    var status: String? { extensions?.value(forKey: "status") }
    var statusCode: Int? { extensions?.value(forKey: "statusCode") }
    var internalErrorCode: String? { extensions?.value(forKey: "internalErrorCode") }
    func data<T>() -> T? { extensions?.value(forKey: "data") }
}

extension Dictionary where Key == String, Value == Any {
    func value<T>(forKey key: String) -> T? {
        return self[key] as? T
    }
}
