//
//  StatementVM.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 09..
//

import Foundation

struct StatementVM: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let selectedAction: () -> Void

    static func == (lhs: StatementVM, rhs: StatementVM) -> Bool {
        lhs.id == rhs.id
    }
}
