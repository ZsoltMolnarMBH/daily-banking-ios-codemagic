//
//  CardsDraftStore.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 21..
//

import Foundation

protocol BankCardStore: Store where State == BankCard? { }

class MemoryBankCardStore: MemoryStore<BankCard?>, BankCardStore {
    init(card: BankCard?) {
        super.init(state: nil)
    }
}
