//
//  UserContract.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 13..
//

import Foundation

struct UserContract {
    let contractID: String
    let title: String
    let signedAt: Date?
    let acceptedAt: Date?
    let uploadedAt: Date?
}
