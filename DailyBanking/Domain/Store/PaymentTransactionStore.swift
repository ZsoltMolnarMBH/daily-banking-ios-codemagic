//
//  PaymentTransactionStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 31..
//

import Foundation

protocol PaymentTransactionStore: Store where State == [PaymentTransaction] { }

class MemoryPaymentTransactionStore: MemoryStore<[PaymentTransaction]>, PaymentTransactionStore {
    init() {
        super.init(state: [])
    }
}
