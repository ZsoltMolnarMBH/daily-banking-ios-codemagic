//
//  BankCardPinStore.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 26..
//

import Foundation
import Resolver

extension Resolver.Name.Card {
    var pin: Resolver.Name {
        .init("card.pin")
    }
}

protocol BankCardPinStore: Store where State == String? { }

class MemoryBankCardPinStore: MemoryStore<String?>, BankCardPinStore {
    init(pin: String?) {
        super.init(state: nil)
    }
}
