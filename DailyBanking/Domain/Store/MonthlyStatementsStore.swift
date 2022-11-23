//
//  MonthlyStatementStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 09..
//

import Foundation

protocol MonthlyStatementsStore: Store where State == [MonthlyStatement] { }

class MemoryMonthlyStatementsStore: MemoryStore<[MonthlyStatement]>, MonthlyStatementsStore {
    init() {
        super.init(state: [])
    }
}
