//
//  PaymentTransactionItemVM.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 31..
//

import Foundation

struct PaymentTransactionItemVM: Identifiable, Equatable {
    enum Status: Equatable {
        case outgoing, incoming, rejected
    }

    enum Detail: Equatable {
        case text(String)
        case fee(String)
    }

    let id: String
    let imageName: ImageName
    let title: String
    let subtitle: String
    let amount: String
    let detail: Detail?
    let status: Status
    let action: () -> Void

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.imageName == rhs.imageName &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.amount == rhs.amount &&
        lhs.status == rhs.status &&
        lhs.detail == rhs.detail
    }
}
