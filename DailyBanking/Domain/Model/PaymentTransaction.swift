//
//  PaymentTransaction.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 31..
//

import Foundation

struct PaymentTransaction {
    enum State: Equatable {
        case pending, completed, rejected
    }

    enum Direction {
        case send, receive
    }

    let id: String
    let name: String
    let createdAt: Date
    let settlementDate: Date?
    let amount: Money
    let fee: Money?
    let state: State
    let direction: Direction
    let accountNumber: String
    let reference: String?
    let rejectionReason: TransferRejection?
}
