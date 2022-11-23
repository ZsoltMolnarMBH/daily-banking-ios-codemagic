//
//  ActionError.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 05. 02..
//

import Foundation

enum AnyActionError: Error {
    case unknown(Error)
    case network(CommunicationError)
    case secondLevelAuth(SecondLevelAuthError)
}

enum ActionError<A: Error>: Error {
    case unknown(Error)
    case network(CommunicationError)
    case secondLevelAuth(SecondLevelAuthError)
    case action(A)
}
