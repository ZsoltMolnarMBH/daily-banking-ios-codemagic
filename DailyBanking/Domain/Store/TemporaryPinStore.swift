//
//  TemporaryPinStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 12..
//

import Foundation

protocol TemporaryPinStore: Store where State == PinCode? { }

class MemoryTemporaryPinStore: MemoryStore<PinCode?>, TemporaryPinStore {
    init() {
        super.init(state: nil)
    }
}
