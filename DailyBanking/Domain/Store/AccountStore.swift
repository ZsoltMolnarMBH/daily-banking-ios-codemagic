//
//  AccountStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 22..
//

import Foundation

protocol AccountStore: Store where State == Account? { }

class MemoryAccountStore: MemoryStore<Account?>, AccountStore {
    init() {
        super.init(state: nil)
    }
}
