//
//  Individual.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 17..
//

import Foundation

struct Individual: Equatable {
    var legalName: Name?
    var birthName: Name?
    var birthData: BirthData?
    var legalAddress: Address?
    var correspondenceAddress: Address?
    var identityCard: Document?
    var addressCard: Document?
    var phoneNumber: String
    var email: Email
}
