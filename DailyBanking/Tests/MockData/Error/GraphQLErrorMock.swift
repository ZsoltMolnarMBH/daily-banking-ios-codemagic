//
//  GraphQLError+Extensions.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 21..
//

import Foundation
import Apollo
import XCTest
import SwiftyMocky
@testable import Apollo

extension GraphQLError {
    static let mock = Mock()
    struct Mock { }

    static func from(string: String) -> GraphQLError {
        if let data = string.data(using: .utf8),
           let error = try? JSONSerializationFormat.deserialize(data: data) as? JSONObject {
            return GraphQLError(error)
        }
        Failure("GraphQLError cannot created")
    }
}

extension GraphQLResultError {
    static let mock = Mock()
    struct Mock { }
}

extension GraphQLResultError.Mock {
    var decodingError: GraphQLResultError {
        GraphQLResultError(
            path: .init(arrayLiteral: "fragment", "field"),
            underlying: Apollo.JSONDecodingError.nullValue)
    }
}
