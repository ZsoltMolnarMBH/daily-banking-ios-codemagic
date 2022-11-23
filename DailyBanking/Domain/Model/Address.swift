//
//  Address.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 06..
//

import Foundation

struct Address: Equatable {
    let country: String
    let city: String
    let postCode: String
    let streetName: String
    let houseNumber: String
}
