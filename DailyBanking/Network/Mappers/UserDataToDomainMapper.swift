//
//  UserDataToDomainMapper.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 08..
//

import Foundation

class UserDataToDomainMapper: Mapper<UserEntity, User> {
    override func map(_ item: UserEntity) throws -> User {
        User(
            name: Name(firstName: item.firstName ?? "", lastName: item.lastName ?? ""),
            phoneNumber: item.phoneNumber ?? ""
        )
    }
}
