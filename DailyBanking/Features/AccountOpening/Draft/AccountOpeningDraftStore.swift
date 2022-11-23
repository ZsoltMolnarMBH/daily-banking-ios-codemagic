//
//  AccountOpeningDraftStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 06..
//

import Foundation

protocol AccountOpeningDraftStore: Store where State == AccountOpeningDraft { }

class MemoryAccountOpeningDraftStore: MemoryStore<AccountOpeningDraft>, AccountOpeningDraftStore {
}
