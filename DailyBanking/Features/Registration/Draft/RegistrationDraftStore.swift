//
//  RegistrationDraftStore.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 04..
//

import Foundation

protocol RegistrationDraftStore: Store where State == RegistrationDraft { }

class MemoryRegistrationDraftStore: MemoryStore<RegistrationDraft>, RegistrationDraftStore {
    init() {
        super.init(state: .init())
    }
}
