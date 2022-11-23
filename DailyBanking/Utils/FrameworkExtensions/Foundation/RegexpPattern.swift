//
//  RegexpPattern.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 22..
//

import Foundation

struct RegExp {
    let pattern: String
}

extension RegExp {
    static let email = RegExp(pattern: #"^\S+@\S+\.\S+$"#)
    static let addressCard = RegExp(pattern: #"[0-9]{6}\s?[A-Z]{2}$"#)
    static let idNumber = RegExp(pattern: #"[0-9]{6}\s?[A-Z]{2}$|RH-II?.?\s?[0-9]{6}$"#)
}
