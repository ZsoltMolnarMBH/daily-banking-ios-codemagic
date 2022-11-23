//
//  IndividualStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 17..
//

import Foundation

protocol IndividualStore: Store where State == Individual? { }

class MemoryIndividualStore: MemoryStore<Individual?>, IndividualStore {
    init() {
        super.init(state: nil)
    }
}
