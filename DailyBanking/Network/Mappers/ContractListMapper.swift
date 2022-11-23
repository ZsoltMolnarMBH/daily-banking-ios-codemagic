//
//  ContractListMapper.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 15..
//

import BankAPI
import Foundation

class ContractListMapper: Mapper<UserContractFragment, UserContract> {
    override func map(_ fragment: UserContractFragment) throws -> UserContract {
        UserContract(
            contractID: fragment.contractId,
            title: fragment.name,
            signedAt: DateFormatter.simple.date(from: fragment.signedAt),
            acceptedAt: DateFormatter.simple.date(from: fragment.acceptedAt),
            uploadedAt: DateFormatter.simple.date(optional: fragment.uploadedAt)
        )
    }
}
