//
//  AccountClosingDraftStore.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 18..
//

import Foundation

protocol AccountClosingDraftStore: Store where State == AccountClosingDraft { }

class MemoryAccountClosingDraftStore: MemoryStore<AccountClosingDraft>, AccountClosingDraftStore {
    init(draft: AccountClosingDraft) {
        super.init(state: draft)
    }
}
