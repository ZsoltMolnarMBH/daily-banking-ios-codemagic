//
//  CommunicationErrorMock.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 23..
//

import Foundation
@testable import DailyBanking

extension CommunicationError {
    static let mock = Mock()
    struct Mock { }
}

extension CommunicationError.Mock {
    var noInternet: CommunicationError {
        .networkError(data: Data(),
                      response: nil,
                      underlying: NSError(
                        domain: "NSURLErrorDomain",
                        code: NSURLErrorNotConnectedToInternet))
    }
}
