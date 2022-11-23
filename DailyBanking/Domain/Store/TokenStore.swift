//
//  TokenStore.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 03..
//

import Foundation

protocol TokenStore: Store where State == Token? { }

class MemoryTokenStore: MemoryStore<Token?>, TokenStore {
    init() {
        super.init(state: nil)
    }
}
