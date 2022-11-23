//
//  UserContractStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 13..
//

import Foundation

protocol UserContractStore: Store where State == [UserContract] { }

class MemoryUserContractStore: MemoryStore<[UserContract]>, UserContractStore {
    init() {
        super.init(state: [])
    }
}
