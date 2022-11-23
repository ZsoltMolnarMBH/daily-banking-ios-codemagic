//
//  BankCardInfoStore.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 26..
//

import Foundation

protocol BankCardInfoStore: Store where State == BankCardInfo? { }

class MemoryBankCardInfoStore: MemoryStore<BankCardInfo?>, BankCardInfoStore {
    init(card: BankCardInfo?) {
        super.init(state: nil)
    }
}
