    //
//  ProfileActionTests.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 18..
//

import XCTest
import Combine
import Resolver
@testable import DailyBanking
import SwiftyMocky
import BankAPI
import Apollo
import SwiftUI

class UserActionTests: BaseTestCase {
}

private class MemoryAuthStore: AuthenticationKeyStore {
    var state: ReadOnly<AuthenticationKey?> {
        .init(stateSubject: subject)
    }
    var modifyInvocations = 0
    let subject = CurrentValueSubject<AuthenticationKey?, Never>(nil)

    func modify(_ transform: @escaping (inout AuthenticationKey?) -> Void) {
        modifyInvocations += 1
        var copy = subject.value
        transform(&copy)
        subject.send(copy)
    }
}

private extension GraphQLError {
    static var invalidPin: GraphQLError {
        .from(string:
            """
            {
                "message": "Unauthorized",
                "locations": [
                    {
                        "line": 2,
                        "column": 3
                    }
                ],
                "path": [
                    "login"
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "WRONG_OTP",
                    "statusCode": 403,
                    "message": "Unauthorized",
                    "errors": [],
                    "data": {"remainingAttempts":4}
                }
            }
            """
        )
    }

    static var forceLogout: GraphQLError {
        .from(string:
            """
            {
                 "message":"Please reactivate the device.",
                 "locations":[
                    {
                       "line":2,
                       "column":3
                    }
                 ],
                 "path":[
                    "login"
                 ],
                 "extensions": {
                    "id": "556cb1e1-31ba-4aab-95ab-0451c268c16e",
                    "status": "FORCE_LOGOUT",
                    "statusCode": 423,
                    "message": "Please reactivate the device.",
                    "errors": [],
                }
            }
            """
        )
    }
}
