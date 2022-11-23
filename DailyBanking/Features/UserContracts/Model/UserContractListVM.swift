//
//  UserContractViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 13..
//

import Foundation

struct UserContractListVM: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String?
    let selectedAction: () -> Void

    static func == (lhs: UserContractListVM, rhs: UserContractListVM) -> Bool {
        lhs.id == rhs.id
    }
}
