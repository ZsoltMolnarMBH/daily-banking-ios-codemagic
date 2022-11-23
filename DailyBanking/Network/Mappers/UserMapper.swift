//
//  UserMapper.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 07..
//

import Foundation

class UserMapper: Mapper<Individual, User?> {
    override func map(_ item: Individual) throws -> User? {
        guard let name = item.legalName else { return nil }
        return .init(name: name, phoneNumber: item.phoneNumber)
    }
}
